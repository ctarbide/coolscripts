#line 18 "bits-to-bytes-in-c.nw"
#line 26 "bits-to-bytes-in-c.nw"
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
#line 19 "bits-to-bytes-in-c.nw"
#line 44 "bits-to-bytes-in-c.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#line 20 "bits-to-bytes-in-c.nw"
#line 52 "bits-to-bytes-in-c.nw"
#define OK			0	/* status code for successful run */
#define usage_error		1	/* status code for improper syntax */
#define cannot_open_file	2	/* status code for file access error */
#define READ_ONLY		0	/* read access code for system open */
#define buf_size	BUFSIZ		/* stdio.h BUFSIZ chosen for efficiency */
#define print_count(i,n) printf("%s%ld", i ? " " : "", n)
#line 21 "bits-to-bytes-in-c.nw"
#line 61 "bits-to-bytes-in-c.nw"
int status = OK;	/* exit status of command, initially OK */
char *prog_name;	/* who we are */
/* total number of words, lines, chars */
long tot_word_count, tot_line_count, tot_char_count;
#line 22 "bits-to-bytes-in-c.nw"
#line 7 "bits-to-bytes-in-c.nw"
int main(int argc, char **argv)
{
#line 139 "bits-to-bytes-in-c.nw"
	int file_count;		/* how many files there are */
	int fd = 0;		/* file descriptor, initialized to stdin */
	char buffer[buf_size];	/* we read the input into this array */
	char *ptr;		/* first unprocessed character in buffer */
	char *buf_end;		/* the first unused position in buffer */
	int out;		/* output char */
	ssize_t nc;		/* # of chars just read */
#line 10 "bits-to-bytes-in-c.nw"
#line 149 "bits-to-bytes-in-c.nw"
	prog_name = argv[0];
#line 11 "bits-to-bytes-in-c.nw"
#line 135 "bits-to-bytes-in-c.nw"
	file_count = argc - 1;
#line 12 "bits-to-bytes-in-c.nw"
#line 124 "bits-to-bytes-in-c.nw"
	argc--;
	do {
#line 108 "bits-to-bytes-in-c.nw"
		if (file_count > 0) {
			char *fname = *(++argv);
			if (strcmp(fname, "-") == 0) {
				fd = 0;
			} else if ((fd = open(fname, READ_ONLY)) < 0) {
				fprintf(stderr,
					"%s: cannot open file %s\n",
					prog_name, *argv);
				status |= cannot_open_file;
				file_count--;
				continue;
			}
		}
#line 127 "bits-to-bytes-in-c.nw"
#line 104 "bits-to-bytes-in-c.nw"
		ptr = buf_end = buffer;
#line 128 "bits-to-bytes-in-c.nw"
#line 88 "bits-to-bytes-in-c.nw"
		while (1) {
#line 79 "bits-to-bytes-in-c.nw"
			if (ptr + 16 > buf_end) {
				ptr = buffer;
				nc = read(fd, ptr, buf_size);
				if (nc <= 0) break;
				buf_end = buffer + nc;
			}
#line 90 "bits-to-bytes-in-c.nw"
			out =	((ptr[0*2] & 1) << 7) |
				((ptr[1*2] & 1) << 6) |
				((ptr[2*2] & 1) << 5) |
				((ptr[3*2] & 1) << 4) |
				((ptr[4*2] & 1) << 3) |
				((ptr[5*2] & 1) << 2) |
				((ptr[6*2] & 1) << 1) |
				((ptr[7*2] & 1) << 0);
			ptr += 16;
			putc(out, stdout);
		}
#line 129 "bits-to-bytes-in-c.nw"
#line 71 "bits-to-bytes-in-c.nw"
		if (fd != 0) {
			close(fd);
		}
#line 130 "bits-to-bytes-in-c.nw"
		/* even if there is only one file */
	} while (--argc > 0);
#line 13 "bits-to-bytes-in-c.nw"
#line 153 "bits-to-bytes-in-c.nw"
	exit(status);
	return 0;
#line 14 "bits-to-bytes-in-c.nw"
}
