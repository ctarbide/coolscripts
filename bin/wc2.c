#line 28 "wc2.nw"
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
#line 46 "wc2.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#line 53 "wc2.nw"
#define OK			0	/* status code for successful run */
#define usage_error		1	/* status code for improper syntax */
#define cannot_open_file	2	/* status code for file access error */
#define READ_ONLY		0	/* read access code for system open */
#define buf_size	BUFSIZ		/* stdio.h BUFSIZ chosen for efficiency */
#define print_count(i,n) printf("%s%8ld", i ? "\t" : "", n)
#line 62 "wc2.nw"
int status = OK;	/* exit status of command, initially OK */
char *prog_name;	/* who we are */
/* total number of words, lines, chars */
long tot_word_count, tot_line_count, tot_char_count;
#line 72 "wc2.nw"
static void wc_print(char *which, long char_count, long word_count, long line_count)
{
	int i = 0;
	while (*which) {
		switch (*which++) {
			case 'l':
				print_count(i++, line_count);
				break;
			case 'w':
				print_count(i++, word_count);
				break;
			case 'c':
				print_count(i++, char_count);
				break;
			default:
				if ((status & usage_error) == 0) {
					fprintf(stderr,
						"\nUsage: %s [-lwc] [filename ...]\n", prog_name);
					status |= usage_error;
				}
		}
	}
}
#line 7 "wc2.nw"
int main(int argc, char **argv)
{
#line 193 "wc2.nw"
	int file_count;		/* how many files there are */
	char *which;		/* which counts to print */
	int fd = 0;		/* file descriptor, initialized to stdin */
	char buffer[buf_size];	/* we read the input into this array */
	char *ptr;		/* first unprocessed character in buffer */
	char *buf_end;		/* the first unused position in buffer */
	int c;			/* current char */
	ssize_t nc;		/* # of chars just read */
	int in_word;		/* are we within a word? */
	long word_count, line_count, char_count;	/* # of words, lines, and chars so far */
#line 206 "wc2.nw"
	prog_name = argv[0];
#line 182 "wc2.nw"
	which = "lwc";
	/* if no option is given, print 3 values */
	if (argc > 1 && *argv[1] == '-') {
		which = argv[1] + 1;
		argc--;
		argv++;
	}
	file_count = argc - 1;
#line 169 "wc2.nw"
	argc--;
	do {
#line 157 "wc2.nw"
		if (file_count > 0
		    && (fd = open(*(++argv), READ_ONLY)) < 0) {
			fprintf(stderr,
				"%s: cannot open file %s\n",
				prog_name, *argv);
			status |= cannot_open_file;
			file_count--;
			continue;
		}
#line 151 "wc2.nw"
		ptr = buf_end = buffer;
		line_count = word_count = char_count = 0;
		in_word = 0;
#line 132 "wc2.nw"
		while (1) {
#line 122 "wc2.nw"
			if (ptr >= buf_end) {
				ptr = buffer;
				nc = read(fd, ptr, buf_size);
				if (nc <= 0) break;
				char_count += nc;
				buf_end = buffer + nc;
			}
#line 134 "wc2.nw"
			c = *ptr++;
			if (c > ' ' && c < 0177) {
				/* visible ASCII codes */
				if (!in_word) {
					word_count++;
					in_word = 1;
				}
				continue;
			}
			if (c == '\n') line_count++;
			else if (c != ' ' && c != '\t') continue;
			in_word = 0;
			/* c is newline, space, or tab */
		}
#line 118 "wc2.nw"
		close(fd);
#line 112 "wc2.nw"
		wc_print(which, char_count, word_count, line_count);
		if (file_count) printf("\t%s\n", *argv);	/* not stdin */
		else printf("\n");				/* stdin */
#line 106 "wc2.nw"
		tot_line_count += line_count;
		tot_word_count += word_count;
		tot_char_count += char_count;
#line 177 "wc2.nw"
		/* even if there is only one file */
	} while (--argc > 0);
#line 98 "wc2.nw"
	if (file_count > 1) {
		wc_print(which, tot_char_count,
			tot_word_count, tot_line_count);
		printf("\ttotal in %d files\n", file_count);
	}
#line 210 "wc2.nw"
	exit(status);
	return 0;
#line 15 "wc2.nw"
}
