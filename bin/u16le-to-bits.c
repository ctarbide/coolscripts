#line 18 "u16le-to-bits-in-c.nw"
#line 26 "u16le-to-bits-in-c.nw"
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
#line 19 "u16le-to-bits-in-c.nw"
#line 44 "u16le-to-bits-in-c.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#line 20 "u16le-to-bits-in-c.nw"
#line 52 "u16le-to-bits-in-c.nw"
#define OK			0	/* status code for successful run */
#define usage_error		1	/* status code for improper syntax */
#define cannot_open_file	2	/* status code for file access error */
#define READ_ONLY		0	/* read access code for system open */
#define buf_size	BUFSIZ		/* stdio.h BUFSIZ chosen for efficiency */
#define print_count(i,n) printf("%s%ld", i ? " " : "", n)
#line 21 "u16le-to-bits-in-c.nw"
#line 61 "u16le-to-bits-in-c.nw"
int status = OK;	/* exit status of command, initially OK */
char *prog_name;	/* who we are */
/* total number of words, lines, chars */
long tot_word_count, tot_line_count, tot_char_count;
#line 22 "u16le-to-bits-in-c.nw"
#line 7 "u16le-to-bits-in-c.nw"
int main(int argc, char **argv)
{
#line 151 "u16le-to-bits-in-c.nw"
	int file_count;		/* how many files there are */
	int fd = 0;		/* file descriptor, initialized to stdin */
	char buffer[buf_size];	/* we read the input into this array */
	char *ptr;		/* first unprocessed character in buffer */
	char *buf_end;		/* the first unused position in buffer */
	int c;			/* current char */
	char out[16*2+1] = {	/* all bits of a byte with \n and \0 */
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
		0, '\n', 0, '\n', 0, '\n', 0, '\n',
#line 159 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
		0, '\n', 0, '\n', 0, '\n', 0, '\n',
#line 160 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
		0, '\n', 0, '\n', 0, '\n', 0, '\n',
#line 161 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
#line 147 "u16le-to-bits-in-c.nw"
		0, '\n', 0, '\n', 0, '\n', 0, '\n',
#line 162 "u16le-to-bits-in-c.nw"
		0};
	ssize_t nc;		/* # of chars just read */
#line 10 "u16le-to-bits-in-c.nw"
#line 167 "u16le-to-bits-in-c.nw"
	prog_name = argv[0];
#line 11 "u16le-to-bits-in-c.nw"
#line 143 "u16le-to-bits-in-c.nw"
	file_count = argc - 1;
#line 12 "u16le-to-bits-in-c.nw"
#line 132 "u16le-to-bits-in-c.nw"
	argc--;
	do {
#line 116 "u16le-to-bits-in-c.nw"
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
#line 135 "u16le-to-bits-in-c.nw"
#line 112 "u16le-to-bits-in-c.nw"
		ptr = buf_end = buffer;
#line 136 "u16le-to-bits-in-c.nw"
#line 86 "u16le-to-bits-in-c.nw"
		while (1) {
#line 77 "u16le-to-bits-in-c.nw"
			if (buf_end - ptr < 2) {
				ptr = buffer;
				nc = read(fd, ptr, buf_size);
				if (nc <= 0) break;
				buf_end = buffer + nc;
			}
#line 88 "u16le-to-bits-in-c.nw"
			c = ptr[1];
			out[0*2] = '0' | ((c & 0x80) >> 7);
			out[1*2] = '0' | ((c & 0x40) >> 6);
			out[2*2] = '0' | ((c & 0x20) >> 5);
			out[3*2] = '0' | ((c & 0x10) >> 4);
			out[4*2] = '0' | ((c & 8) >> 3);
			out[5*2] = '0' | ((c & 4) >> 2);
			out[6*2] = '0' | ((c & 2) >> 1);
			out[7*2] = '0' | ((c & 1) >> 0);
			c = ptr[0];
			out[8*2] = '0' | ((c & 0x80) >> 7);
			out[9*2] = '0' | ((c & 0x40) >> 6);
			out[10*2] = '0' | ((c & 0x20) >> 5);
			out[11*2] = '0' | ((c & 0x10) >> 4);
			out[12*2] = '0' | ((c & 8) >> 3);
			out[13*2] = '0' | ((c & 4) >> 2);
			out[14*2] = '0' | ((c & 2) >> 1);
			out[15*2] = '0' | ((c & 1) >> 0);
			ptr += 2;
			fputs(out, stdout);
		}
#line 137 "u16le-to-bits-in-c.nw"
#line 71 "u16le-to-bits-in-c.nw"
		if (fd != 0) {
			close(fd);
		}
#line 138 "u16le-to-bits-in-c.nw"
		/* even if there is only one file */
	} while (--argc > 0);
#line 13 "u16le-to-bits-in-c.nw"
#line 171 "u16le-to-bits-in-c.nw"
	exit(status);
	return 0;
#line 14 "u16le-to-bits-in-c.nw"
}
