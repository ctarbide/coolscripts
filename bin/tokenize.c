#line 132 "tokenize.nw"
#line 143 "tokenize.nw"
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
#line 133 "tokenize.nw"
#line 158 "tokenize.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <ctype.h>
#line 134 "tokenize.nw"
#line 180 "tokenize.nw"
#define OK                  0   /* status code for successful run */
#define CANNOT_OPEN_FILE    1   /* status code for file access error */
#define LINE_TOO_LONG       2   /* line longer than BUF_SIZE - 1 */
#define READ_ONLY           0   /* read access code for system open */
#line 172 "tokenize.nw"
#if BUFSIZ >= 512
#define BUF_SIZE            BUFSIZ
#else
#define BUF_SIZE            512
#endif
#line 185 "tokenize.nw"
#line 84 "tokenize.nw"
#define CONVERT_CRLF_TO_LF 1
#line 349 "tokenize.nw"
#line 16 "strscan.nw"
#define STRSCAN_PTR(ctx) ((ctx)->beg + (ctx)->pos)
#define STRSCAN_LEN(ctx) ((ctx)->end - STRSCAN_PTR(ctx))
#line 135 "tokenize.nw"
#line 351 "tokenize.nw"
#line 9 "strscan.nw"
struct strscan {
    char *beg, *end;
    int pos, fail;
};
#line 136 "tokenize.nw"
#line 355 "tokenize.nw"
#line 21 "strscan.nw"
void
strscan(struct strscan *ctx, char *s, size_t len);
#line 37 "strscan.nw"
void rtrim(struct strscan *ctx);
#line 54 "strscan.nw"
int
startswith2(struct strscan *ctx, int x, int y);
#line 77 "strscan.nw"
int
endswith3(struct strscan *ctx, int x, int y, int z);
#line 100 "strscan.nw"
int
exact1(struct strscan *ctx, int x);
#line 123 "strscan.nw"
int
hasatleast(struct strscan *ctx, size_t len);
#line 137 "tokenize.nw"
#line 189 "tokenize.nw"
int status = OK;        /* exit status of command, initially OK */
char *prog_name;        /* who we are */
long tot_line_count;    /* total number of lines */
#line 138 "tokenize.nw"
#line 353 "tokenize.nw"
#line 26 "strscan.nw"
void
strscan(struct strscan *ctx, char *s, size_t len)
{
    ctx->beg = s;
    ctx->end = s + len;
    ctx->pos = 0;
    ctx->fail = 0;
}
#line 41 "strscan.nw"
void rtrim(struct strscan *ctx)
{
    char *b = ctx->beg + ctx->pos;
    char *e = ctx->end - 1;
    if (ctx->fail) return;
    while (e >= b && (*e == ' ' || *e == '\t')) {
        e--;
    }
    ctx->end = e + 1;
}
#line 59 "strscan.nw"
int
startswith2(struct strscan *ctx, int x, int y)
{
    char *b = ctx->beg + ctx->pos;
    size_t l = ctx->end - b;
    if (ctx->fail) return 0;
    if (l < 2) {
        return 0;
    }
    if (b[0] == x && b[1] == y) {
        ctx->pos += 2;
        return 1;
    }
    return 0;
}
#line 82 "strscan.nw"
int
endswith3(struct strscan *ctx, int x, int y, int z)
{
    char *e = ctx->end;
    size_t l = e - (ctx->beg + ctx->pos);
    if (ctx->fail) return 0;
    if (l < 3) {
        return 0;
    }
    if (e[-3] == x && e[-2] == y && e[-1] == z) {
        ctx->end = e - 3;
        return 1;
    }
    return 0;
}
#line 105 "strscan.nw"
int
exact1(struct strscan *ctx, int x)
{
    char *b = ctx->beg + ctx->pos;
    size_t l = ctx->end - b;
    if (ctx->fail) return 0;
    if (l != 1) {
        return 0;
    }
    if (b[0] == x) {
        ctx->pos++;
        return 1;
    }
    return 0;
}
#line 128 "strscan.nw"
int
hasatleast(struct strscan *ctx, size_t len)
{
    if (ctx->fail) return 0;
    if ((ctx->end - (ctx->beg + ctx->pos)) >= (ssize_t)len) {
        return 1;
    }
    return 0;
}
#line 139 "tokenize.nw"
#line 121 "tokenize.nw"
int main(int argc, char **argv)
{
#line 29 "tokenize.nw"
    int need_nl = 0;
#line 325 "tokenize.nw"
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
#line 124 "tokenize.nw"
#line 340 "tokenize.nw"
    prog_name = argv[0];
#line 125 "tokenize.nw"
#line 321 "tokenize.nw"
    file_count = argc - 1;
#line 126 "tokenize.nw"
#line 310 "tokenize.nw"
    argc--;
    do {
#line 291 "tokenize.nw"
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
#line 313 "tokenize.nw"
#line 286 "tokenize.nw"
        line_start = ptr = buffer;
        line_count = 0;
#line 314 "tokenize.nw"
#line 277 "tokenize.nw"
        line_start = ptr = buffer;
        nc = read(fd, ptr, BUF_SIZE);
        if (nc > 0) {
            buf_end = buffer + nc;
#line 245 "tokenize.nw"
#line 15 "tokenize.nw"
#line 37 "tokenize.nw"
            if (need_nl) {
                putc('\n', stdout);
                need_nl = 0;
            }
#line 16 "tokenize.nw"
            printf("0 %s\n", file_name);
#line 246 "tokenize.nw"
            while (got_eof == 0) {
#line 203 "tokenize.nw"
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
#line 248 "tokenize.nw"
                c = *ptr++;
                if (c == '\n') {
                    /* lf or cr-lf */
            #if CONVERT_CRLF_TO_LF
                    ptr -= got_cr;
                    *(ptr - 1) = '\n';
            #endif
                    line_count++;
                    {
#line 105 "tokenize.nw"
#line 33 "tokenize.nw"
                        char *b, *e;
#line 96 "tokenize.nw"
                        size_t line_length = ptr - line_start;
                        struct strscan ctx[1];
#line 106 "tokenize.nw"
#line 88 "tokenize.nw"
                        if (line_length == 0) {
                            fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                            exit(1);
                        }
                        line_length--;
#line 107 "tokenize.nw"
#line 101 "tokenize.nw"
                        strscan(ctx, line_start, line_length);
#line 108 "tokenize.nw"
                        /*<<show line>>*/
#line 44 "tokenize.nw"
                        b = ctx->beg;
                        e = ctx->end;
                        while (b < e) {
                            c = *b++;
                            if (isalnum(c) || c == '_') {
                                if (need_nl) {
                                    if (need_nl != 1) {
                                        printf("\n3 ");
                                    }
                                } else {
                                    printf("3 ");
                                }
                                putc(c, stdout);
                                need_nl = 1;
                            } else if (c == ' ' || c == '\t') {
                                if (need_nl) {
                                    if (need_nl != 2) {
                                        printf("\n4 ");
                                    }
                                } else {
                                    printf("4 ");
                                }
                                putc(c, stdout);
                                need_nl = 2;
                            } else if (ispunct(c)) {
#line 37 "tokenize.nw"
                                if (need_nl) {
                                    putc('\n', stdout);
                                    need_nl = 0;
                                }
#line 70 "tokenize.nw"
                                printf("5 %c\n", c);
                            } else if (c <= 127) {
#line 37 "tokenize.nw"
                                if (need_nl) {
                                    putc('\n', stdout);
                                    need_nl = 0;
                                }
#line 73 "tokenize.nw"
                                printf("6 %02x\n", c);
                            } else {
                                /* maybe utf-8, decode later */
                                fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                                exit(1);
                            }
                        }
#line 37 "tokenize.nw"
                        if (need_nl) {
                            putc('\n', stdout);
                            need_nl = 0;
                        }
#line 110 "tokenize.nw"
#line 20 "tokenize.nw"
#line 37 "tokenize.nw"
                        if (need_nl) {
                            putc('\n', stdout);
                            need_nl = 0;
                        }
#line 21 "tokenize.nw"
                        printf("1 %ld\n", line_count);
#line 258 "tokenize.nw"
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
#line 25 "tokenize.nw"
            printf("2 \n");
#line 282 "tokenize.nw"
        }
#line 315 "tokenize.nw"
#line 199 "tokenize.nw"
        close(fd);
#line 316 "tokenize.nw"
#line 195 "tokenize.nw"
        tot_line_count += line_count;
#line 317 "tokenize.nw"
    } while (--argc > 0);
#line 127 "tokenize.nw"
#line 344 "tokenize.nw"
    exit(status);
    return 0;
#line 128 "tokenize.nw"
}
