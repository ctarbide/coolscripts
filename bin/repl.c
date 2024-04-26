#line 38 "repl.nw"
#line 46 "repl.nw"
#ifndef _BSD_SOURCE
#define _BSD_SOURCE
#endif
#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE
#endif
#ifndef _XOPEN_SOURCE
#define _XOPEN_SOURCE 600
#endif
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE 200112L
#endif
#line 39 "repl.nw"
#line 61 "repl.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#line 40 "repl.nw"
#line 82 "repl.nw"
#define OK                  0   /* status code for successful run */
#define CANNOT_OPEN_FILE    1   /* status code for file access error */
#define LINE_TOO_LONG       2   /* line longer than BUF_SIZE - 1 */
#define READ_ONLY           0   /* read access code for system open */
#line 74 "repl.nw"
#if BUFSIZ >= 512
#define BUF_SIZE            BUFSIZ
#else
#define BUF_SIZE            512
#endif
#line 87 "repl.nw"
#line 11 "repl.nw"
#define CONVERT_CRLF_TO_LF 1
#line 41 "repl.nw"
#line 91 "repl.nw"
int status = OK;        /* exit status of command, initially OK */
char *prog_name;        /* who we are */
long tot_line_count;    /* total number of lines */
#line 42 "repl.nw"
#line 27 "repl.nw"
int main(int argc, char **argv)
{
#line 225 "repl.nw"
    int file_count;         /* how many files there are */
    char *file_name;        /* Used to differentiate between *argv and '-' */
    int fd;                 /* file descriptor */
    char buffer[BUF_SIZE];  /* we read the input into this array */
    char *ptr;              /* first unprocessed character in buffer */
    char *line_start;       /* where in the buffer the current line starts */
    char *buf_end;          /* the first unused position in buffer */
    int c;                  /* current char */
    ssize_t nc;             /* # of chars just read */
    long line_count;        /* # of words, lines, and chars so far */
    int got_eof = 0;        /* read got EOF */
    int got_cr = 0;         /* previous char was '\r' */
#line 30 "repl.nw"
#line 240 "repl.nw"
    prog_name = argv[0];
#line 31 "repl.nw"
#line 221 "repl.nw"
    file_count = argc - 1;
#line 32 "repl.nw"
#line 210 "repl.nw"
    argc--;
    do {
#line 191 "repl.nw"
        if (file_count > 0) {
            file_name = *(++argv);
            if (strcmp(file_name, "-") == 0) {
                fd = 0; /* stdin */
            } else if ((fd = open(file_name, READ_ONLY)) < 0) {
                fprintf(stderr,
                    "%s: cannot open file %s\n",
                    prog_name, file_name);
                status |= CANNOT_OPEN_FILE;
                file_count--;
                continue;
            }
        } else {
            fd = 0; /* stdin */
            file_name = "-";
        }
#line 213 "repl.nw"
#line 186 "repl.nw"
        line_start = ptr = buffer;
        line_count = 0;
#line 214 "repl.nw"
#line 177 "repl.nw"
        line_start = ptr = buffer;
        nc = read(fd, ptr, BUF_SIZE);
        if (nc > 0) {
            buf_end = buffer + nc;
#line 147 "repl.nw"
            while (got_eof == 0) {
#line 105 "repl.nw"
                if (ptr >= buf_end) {
                    size_t consumed = ptr - buffer;
                    size_t remaining = BUF_SIZE - consumed;
                    if (remaining == 0) {
                        size_t line_length = ptr - line_start;
                        if (line_start == buffer) {
                            fprintf(stderr,
                                "Error in %s, line %s:%lu is too long, greater than %lu\n",
                                prog_name, file_name, line_count + 1,
                                (unsigned long)(buf_end - buffer));
                            status |= LINE_TOO_LONG;
                            break;
                        }
                        line_start = memmove(buffer, line_start, line_length);
                        ptr = buf_end = line_start + line_length;
                        consumed = line_length;
                        remaining = BUF_SIZE - consumed;
                    }
                    nc = read(fd, ptr, remaining);
                    if ((got_eof = (nc <= 0))) {
                        if (buf_end > line_start && *(buf_end-1) != '\n') {
                            if (got_cr) {
                                /* a CR by itself is always converted to a LF */
                                got_cr = 0;
                                *(buf_end-1) = '\n';
                                ptr--; /* repeat */
                            } else {
                                *buf_end++ = '\n';
                                consumed++;
                                remaining--;
                                got_eof = 0; /* retry */
                            }
                        } else {
                            break;
                        }
                    } else {
                        buf_end = ptr + nc;
                    }
                }
#line 149 "repl.nw"
                c = *ptr++;
                if (c == '\n') {
                    /* lf or cr-lf */
            #if CONVERT_CRLF_TO_LF
                    ptr -= got_cr;
                    *(ptr - 1) = '\n';
            #endif
                    line_count++;
                    {
#line 19 "repl.nw"
#line 15 "repl.nw"
                        size_t line_length = ptr - line_start;
#line 20 "repl.nw"
                        printf("**** line %s:%lu has %lu bytes: [", file_name, line_count,
                            (unsigned long)line_length);
                        fwrite(line_start, line_length, 1, stdout);
                        printf("]\n");
#line 159 "repl.nw"
                    }
            #if CONVERT_CRLF_TO_LF
                    ptr += got_cr;
            #endif
                    line_start = ptr;
                    got_cr = 0;
                } else if (got_cr) {
                    /* cr, convert to lf and repeat */
                    got_cr = 0;
                    ptr -= 2;
                    *ptr = '\n';
                } else {
                    got_cr = c == '\r';
                }
            }
#line 182 "repl.nw"
        }
#line 215 "repl.nw"
#line 101 "repl.nw"
        close(fd);
#line 216 "repl.nw"
#line 97 "repl.nw"
        tot_line_count += line_count;
#line 217 "repl.nw"
    } while (--argc > 0);
#line 33 "repl.nw"
#line 244 "repl.nw"
    exit(status);
    return 0;
#line 34 "repl.nw"
}
