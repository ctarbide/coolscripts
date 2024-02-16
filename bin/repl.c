#line 38 "repl.nw"
#ifndef _BSD_SOURCE
#define _BSD_SOURCE
#endif

#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE
#endif

#ifndef _XOPEN_SOURCE
#define _XOPEN_SOURCE		600
#endif

#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE		200112L
#endif
#line 56 "repl.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#line 66 "repl.nw"
#define OK			0	/* status code for successful run */
#define cannot_open_file	1	/* status code for file access error */
#define line_too_long		2	/* line longer than BUF_SIZE - 1 */
#define READ_ONLY		0	/* read access code for system open */
#if BUFSIZ >= 512
#define BUF_SIZE	BUFSIZ		/* stdio.h BUFSIZ chosen for efficiency */
#else
#define BUF_SIZE	512
#endif
#define print_count(i,n) printf("%s%8ld", i ? "\t" : "", n)
#line 79 "repl.nw"
int status = OK;	/* exit status of command, initially OK */
char *prog_name;	/* who we are */
/* total number of lines */
long tot_line_count;
#line 19 "repl.nw"
int main(int argc, char **argv)
{
#line 186 "repl.nw"
	int file_count;		/* how many files there are */
	char *file_name;	/* Used to differentiate between *argv and '-' */
	int fd;			/* file descriptor */
	char buffer[BUF_SIZE];	/* we read the input into this array */
	char *ptr;		/* first unprocessed character in buffer */
	char *line_start;	/* where in the buffer the current line starts */
	char *buf_end;		/* the first unused position in buffer */
	int c;			/* current char */
	ssize_t nc;		/* # of chars just read */
	long line_count;	/* # of words, lines, and chars so far */
#line 199 "repl.nw"
	prog_name = argv[0];
#line 182 "repl.nw"
	file_count = argc - 1;
#line 171 "repl.nw"
	argc--;
	do {
#line 152 "repl.nw"
		if (file_count > 0) {
			file_name = *(++argv);
			if (strcmp(file_name, "-") == 0) {
				fd = 0; /* stdin */
			} else if ((fd = open(file_name, READ_ONLY)) < 0) {
				fprintf(stderr,
					"%s: cannot open file %s\n",
					prog_name, file_name);
				status |= cannot_open_file;
				file_count--;
				continue;
			}
		} else {
			fd = 0; /* stdin */
			file_name = "-";
		}
#line 147 "repl.nw"
		line_start = ptr = buf_end = buffer;
		line_count = 0;
#line 138 "repl.nw"
		line_start = ptr = buffer;
		nc = read(fd, ptr, BUF_SIZE);
		if (nc > 0) {
			buf_end = buffer + nc;
#line 125 "repl.nw"
			while (1) {
#line 115 "repl.nw"
				if (ptr >= buf_end) {
#line 98 "repl.nw"
					if (line_start == buffer) {
						if (buf_end - buffer < BUF_SIZE) {
							/* got EOF on an incomplete line */
							*buf_end++ = '\n';
							continue;
						} else {
							fprintf(stderr,
								"%s: line %s:%lu is too long, greater than %zu\n",
								prog_name, file_name, line_count + 1,
								(size_t)(buf_end - buffer));
							status |= line_too_long;
							break;
						}
					}
#line 117 "repl.nw"
					line_start = ptr = buffer;
					nc = read(fd, ptr, BUF_SIZE);
					if (nc <= 0) break;
					buf_end = buffer + nc;
				}
#line 127 "repl.nw"
				c = *ptr++;
				if (c == '\n') {
#line 11 "repl.nw"
					size_t line_length = ptr - line_start;
#line 130 "repl.nw"
					line_count++;
#line 13 "repl.nw"
					printf("**** line %s:%lu has %zu bytes: [", file_name, line_count, line_length);
					fwrite(line_start, line_length, 1, stdout);
					printf("]\n");
#line 132 "repl.nw"
					line_start = ptr;
				}
			}
#line 143 "repl.nw"
		}
#line 92 "repl.nw"
		close(fd);
#line 88 "repl.nw"
		tot_line_count += line_count;
#line 178 "repl.nw"
	} while (--argc > 0);
#line 203 "repl.nw"
	exit(status);
	return 0;
#line 26 "repl.nw"
}
