#line 152 "tokenize.nw"
#line 163 "tokenize.nw"
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
#line 153 "tokenize.nw"
#line 178 "tokenize.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <assert.h>
#line 154 "tokenize.nw"
#line 200 "tokenize.nw"
#define OK                  0   /* status code for successful run */
#define CANNOT_OPEN_FILE    1   /* status code for file access error */
#define LINE_TOO_LONG       2   /* line longer than BUF_SIZE - 1 */
#define READ_ONLY           0   /* read access code for system open */
#line 192 "tokenize.nw"
#if BUFSIZ >= 512
#define BUF_SIZE            BUFSIZ
#else
#define BUF_SIZE            512
#endif
#line 205 "tokenize.nw"
#line 102 "tokenize.nw"
#define CONVERT_CRLF_TO_LF 1
#line 327 "tokenize.nw"
#line 16 "strscan.nw"
#define STRSCAN_PTR(ctx) ((ctx)->beg + (ctx)->pos)
#define STRSCAN_LEN(ctx) ((size_t)((ctx)->end - STRSCAN_PTR(ctx)))
#line 155 "tokenize.nw"
#line 329 "tokenize.nw"
#line 9 "strscan.nw"
struct strscan {
    char *beg, *end;
    int pos, fail;
};
#line 156 "tokenize.nw"
#line 333 "tokenize.nw"
#line 3 "localely-dist.nw"
int C_isascii(int ch);
#line 13 "localely-dist.nw"
int C_isspace(int ch);
#line 23 "localely-dist.nw"
int C_iscntrl(int ch);
#line 33 "localely-dist.nw"
int C_isprint(int ch);
#line 43 "localely-dist.nw"
int C_isblank(int ch);
#line 53 "localely-dist.nw"
int C_isgraph(int ch);
#line 63 "localely-dist.nw"
int C_isupper(int ch);
#line 73 "localely-dist.nw"
int C_islower(int ch);
#line 83 "localely-dist.nw"
int C_isalpha(int ch);
#line 93 "localely-dist.nw"
int C_isdigit(int ch);
#line 103 "localely-dist.nw"
int C_isalnum(int ch);
#line 113 "localely-dist.nw"
int C_ispunct(int ch);
#line 123 "localely-dist.nw"
int C_isxdigit(int ch);
#line 133 "localely-dist.nw"
int C_toupper(int ch);
#line 141 "localely-dist.nw"
int C_tolower(int ch);
#line 21 "strscan.nw"
char *
strscan_strdup(struct strscan *ctx);
#line 42 "strscan.nw"
void
strscan(struct strscan *ctx, char *s, size_t len);
#line 58 "strscan.nw"
void rtrim(struct strscan *ctx);
#line 75 "strscan.nw"
int
startswith2(struct strscan *ctx, int x, int y);
#line 95 "strscan.nw"
int
endswith3(struct strscan *ctx, int x, int y, int z);
#line 115 "strscan.nw"
int
exact1(struct strscan *ctx, int x);
#line 135 "strscan.nw"
int
hasatleast(struct strscan *ctx, size_t len);
#line 157 "tokenize.nw"
#line 209 "tokenize.nw"
int status = OK;        /* exit status of command, initially OK */
char *prog_name;        /* who we are */
long tot_line_count;    /* total number of lines */
#line 158 "tokenize.nw"
#line 331 "tokenize.nw"
#line 5 "localely-dist.nw"
int C_isascii(int ch)
   {
   int r;
   r = (ch < 128 && ch >= 0);
   return r;
   }
#line 15 "localely-dist.nw"
int C_isspace(int ch)
   {
   int r;
   r = (ch >= 9 && ch <= 13) || ch == 32;
   return r;
   }
#line 25 "localely-dist.nw"
int C_iscntrl(int ch)
   {
   int r;
   r = (ch < 32 || ch == 127) && (ch < 128 && ch >= 0);
   return r;
   }
#line 35 "localely-dist.nw"
int C_isprint(int ch)
   {
   int r;
   r = !(ch < 32 || ch == 127) && (ch < 128 && ch >= 0);
   return r;
   }
#line 45 "localely-dist.nw"
int C_isblank(int ch)
   {
   int r;
   r = ch == 32 || ch == 9;
   return r;
   }
#line 55 "localely-dist.nw"
int C_isgraph(int ch)
   {
   int r;
   r = ch > 32 && ch < 127;
   return r;
   }
#line 65 "localely-dist.nw"
int C_isupper(int ch)
   {
   int r;
   r = (ch >= 65 && ch <= 90);
   return r;
   }
#line 75 "localely-dist.nw"
int C_islower(int ch)
   {
   int r;
   r = (ch >= 97 && ch <= 122);
   return r;
   }
#line 85 "localely-dist.nw"
int C_isalpha(int ch)
   {
   int r;
   r = ((ch >= 97 && ch <= 122) || (ch >= 65 && ch <= 90));
   return r;
   }
#line 95 "localely-dist.nw"
int C_isdigit(int ch)
   {
   int r;
   r = (ch >= 48 && ch <= 57);
   return r;
   }
#line 105 "localely-dist.nw"
int C_isalnum(int ch)
   {
   int r;
   r = ((ch >= 97 && ch <= 122) || (ch >= 65 && ch <= 90)) || (ch >= 48 && ch <= 57);
   return r;
   }
#line 115 "localely-dist.nw"
int C_ispunct(int ch)
   {
   int r;
   r = (ch >= 33 && ch <= 47) || (ch >= 58 && ch <= 64) || (ch >= 91 && ch <= 96) || (ch >= 123 && ch <= 126);
   return r;
   }
#line 125 "localely-dist.nw"
int C_isxdigit(int ch)
   {
   int r;
   r = (ch >= 65 && ch <= 70) || (ch >= 97 && ch <= 102) || (ch >= 48 && ch <= 57);
   return r;
   }
#line 135 "localely-dist.nw"
int C_toupper(int ch)
   {
   return (ch >= 97 && ch <= 122) ? ch ^ 0x20 : ch;
   }
#line 143 "localely-dist.nw"
int C_tolower(int ch)
   {
   return (ch >= 65 && ch <= 90) ? ch ^ 0x20 : ch;
   }
#line 26 "strscan.nw"
char *
strscan_strdup(struct strscan *ctx)
{
    char *res, *src;
    size_t len;
    src = STRSCAN_PTR(ctx);
    assert(ctx->end >= src);
    len = (size_t)(ctx->end - src);
    res = malloc(len + 1);
    memcpy(res, src, len);
    res[len] = '\0';
    return res;
}
#line 47 "strscan.nw"
void
strscan(struct strscan *ctx, char *s, size_t len)
{
    ctx->beg = s;
    ctx->end = s + len;
    ctx->pos = 0;
    ctx->fail = 0;
}
#line 62 "strscan.nw"
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
#line 80 "strscan.nw"
int
startswith2(struct strscan *ctx, int x, int y)
{
    char *b = ctx->beg + ctx->pos;
    if (ctx->fail) return 0;
    if (b + 2 > ctx->end) return 0;
    if (b[0] == x && b[1] == y) {
        ctx->pos += 2;
        return 1;
    }
    return 0;
}
#line 100 "strscan.nw"
int
endswith3(struct strscan *ctx, int x, int y, int z)
{
    char *e = ctx->end;
    if (ctx->fail) return 0;
    if (ctx->beg + ctx->pos + 3 > e) return 0;
    if (e[-3] == x && e[-2] == y && e[-1] == z) {
        ctx->end = e - 3;
        return 1;
    }
    return 0;
}
#line 120 "strscan.nw"
int
exact1(struct strscan *ctx, int x)
{
    char *b = ctx->beg + ctx->pos;
    if (ctx->fail) return 0;
    if (b + 1 > ctx->end) return 0;
    if (b[0] == x) {
        ctx->pos++;
        return 1;
    }
    return 0;
}
#line 140 "strscan.nw"
int
hasatleast(struct strscan *ctx, size_t len)
{
    if (ctx->fail) return 0;
    return ctx->beg + ctx->pos + len <= ctx->end;
}
#line 159 "tokenize.nw"
#line 141 "tokenize.nw"
int main(int argc, char **argv)
{
#line 29 "tokenize.nw"
    int need_nl = 0;
#line 303 "tokenize.nw"
    int file_count;         /* how many files there are */
    char *file_name;        /* Used to differentiate between *argv and '-' */
    int fd;                 /* file descriptor */
    char buffer[BUF_SIZE];  /* we read the input into this array */
    char *line_start;       /* where in the buffer the current line starts */
    char *line_end;         /* first unprocessed character in buffer */
    char *buf_end;          /* the first unused position in buffer */
    int c;                  /* current char */
    ssize_t nc;             /* # of chars just read */
    long line_count;        /* # of words, lines, and chars so far */
    int got_eof = 0;        /* read got EOF */
    int got_cr = 0;         /* previous char was '\r' */
#line 144 "tokenize.nw"
#line 318 "tokenize.nw"
    prog_name = argv[0];
#line 145 "tokenize.nw"
#line 299 "tokenize.nw"
    file_count = argc - 1;
#line 146 "tokenize.nw"
#line 288 "tokenize.nw"
    argc--;
    do {
#line 269 "tokenize.nw"
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
#line 291 "tokenize.nw"
#line 264 "tokenize.nw"
        line_start = line_end = buffer;
        line_count = 0;
#line 292 "tokenize.nw"
#line 255 "tokenize.nw"
        line_start = line_end = buffer;
        nc = read(fd, line_end, BUF_SIZE);
        if (nc > 0) {
            buf_end = buffer + nc;
#line 223 "tokenize.nw"
#line 15 "tokenize.nw"
#line 37 "tokenize.nw"
            if (need_nl) {
                putc('\n', stdout);
                need_nl = 0;
            }
#line 16 "tokenize.nw"
            printf("0 %s\n", file_name);
#line 224 "tokenize.nw"
            while (got_eof == 0) {
#line 2 "tokenize--imports.nw"
                if (line_end >= buf_end) {
                    size_t consumed, remaining;
                    assert(line_end >= buffer);
                    consumed = (size_t)(line_end - buffer);
                    assert(BUF_SIZE >= consumed);
                    remaining = (size_t)(BUF_SIZE - consumed);
                    if (remaining == 0) {
                        size_t line_length;
                        assert(line_end >= line_start);
                        line_length = (size_t)(line_end - line_start);
                        if (line_start == buffer) {
                            fprintf(stderr,
                                "Error in %s, line %s:%lu is too long, greater than %lu\n",
                                prog_name, file_name, line_count + 1,
                                (unsigned long)(buf_end - buffer));
                            status |= LINE_TOO_LONG;
                            break;
                        }
                        line_start = memmove(buffer, line_start, line_length);
                        line_end = buf_end = line_start + line_length;
                        consumed = line_length;
                        remaining = BUF_SIZE - consumed;
                    }
                    nc = read(fd, line_end, remaining);
                    if ((got_eof = (nc <= 0))) {
                        if (buf_end > line_start && *(buf_end-1) != '\n') {
                            if (got_cr) {
                                /* a CR by itself is always converted to a LF */
                                got_cr = 0;
                                *(buf_end-1) = '\n';
                                line_end--; /* repeat */
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
                        buf_end = line_end + nc;
                    }
                }
#line 226 "tokenize.nw"
                c = *line_end++;
                if (c == '\n') {
                    /* lf or cr-lf */
            #if CONVERT_CRLF_TO_LF
                    line_end -= got_cr;
                    *(line_end - 1) = '\n';
            #endif
                    line_count++;
                    {
#line 123 "tokenize.nw"
#line 33 "tokenize.nw"
                        char *b, *e;
#line 114 "tokenize.nw"
                        size_t line_length;
                        struct strscan ctx[1];
#line 124 "tokenize.nw"
                        assert(line_end >= line_start);
                        line_length = (size_t)(line_end - line_start);
#line 106 "tokenize.nw"
                        if (line_length == 0) {
                            fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                            exit(1);
                        }
                        line_length--;
#line 127 "tokenize.nw"
#line 119 "tokenize.nw"
                        strscan(ctx, line_start, line_length);
#line 128 "tokenize.nw"
                        /*<<show line>>*/
#line 44 "tokenize.nw"
                        b = ctx->beg;
                        e = ctx->end;
                        while (b < e) {
                            c = *b++;
                            if (C_isalpha(c)) {
                                if (need_nl) {
                                    if (need_nl != 1) {
                                        printf("\n3 ");
                                    }
                                } else {
                                    printf("3 ");
                                }
                                putc(c, stdout);
                                need_nl = 1;
                            } else if (C_isdigit(c)) {
                                if (need_nl) {
                                    if (need_nl != 2) {
                                        printf("\n4 ");
                                    }
                                } else {
                                    printf("4 ");
                                }
                                putc(c, stdout);
                                need_nl = 2;
                            } else if (c == ' ' || c == '\t') {
                                if (need_nl) {
                                    if (need_nl != 3) {
                                        printf("\n5 ");
                                    }
                                } else {
                                    printf("5 ");
                                }
                                putc(c, stdout);
                                need_nl = 3;
                            } else if (C_ispunct(c)) {
#line 37 "tokenize.nw"
                                if (need_nl) {
                                    putc('\n', stdout);
                                    need_nl = 0;
                                }
#line 80 "tokenize.nw"
                                putc('6', stdout);
                                putc(' ', stdout);
                                putc(c, stdout);
                                putc('\n', stdout);
                            } else if (c <= 127) {
#line 37 "tokenize.nw"
                                if (need_nl) {
                                    putc('\n', stdout);
                                    need_nl = 0;
                                }
#line 86 "tokenize.nw"
                                putc('7', stdout);
                                putc(' ', stdout);
                                /* 0x00..0xFF -> 0y@@..0yOO */
                                putc(((c >> 4) & 0xf) | 0x40, stdout);
                                putc((c & 0xf) | 0x40, stdout);
                                putc('\n', stdout);
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
#line 130 "tokenize.nw"
#line 20 "tokenize.nw"
#line 37 "tokenize.nw"
                        if (need_nl) {
                            putc('\n', stdout);
                            need_nl = 0;
                        }
#line 21 "tokenize.nw"
                        printf("1 %ld\n", line_count);
#line 236 "tokenize.nw"
                    }
            #if CONVERT_CRLF_TO_LF
                    line_end += got_cr;
            #endif
                    line_start = line_end;
                    got_cr = 0;
                } else if (got_cr) {
                    /* cr, convert to lf and repeat */
                    got_cr = 0;
                    line_end -= 2;
                    *line_end = '\n';
                } else {
                    got_cr = c == '\r';
                }
            }
#line 25 "tokenize.nw"
            printf("2 \n");
#line 260 "tokenize.nw"
        }
#line 293 "tokenize.nw"
#line 219 "tokenize.nw"
        close(fd);
#line 294 "tokenize.nw"
#line 215 "tokenize.nw"
        tot_line_count += line_count;
#line 295 "tokenize.nw"
    } while (--argc > 0);
#line 147 "tokenize.nw"
#line 322 "tokenize.nw"
    exit(status);
    return 0;
#line 148 "tokenize.nw"
}
