#line 103 "detokenize.nw"
#line 114 "detokenize.nw"
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
#line 104 "detokenize.nw"
#line 129 "detokenize.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <ctype.h>
#line 105 "detokenize.nw"
#line 151 "detokenize.nw"
#define OK                  0   /* status code for successful run */
#define CANNOT_OPEN_FILE    1   /* status code for file access error */
#define LINE_TOO_LONG       2   /* line longer than BUF_SIZE - 1 */
#define READ_ONLY           0   /* read access code for system open */
#line 143 "detokenize.nw"
#if BUFSIZ >= 512
#define BUF_SIZE            BUFSIZ
#else
#define BUF_SIZE            512
#endif
#line 156 "detokenize.nw"
#line 15 "detokenize.nw"
#define CONVERT_CRLF_TO_LF 1
#line 318 "detokenize.nw"
#line 16 "strscan.nw"
#define STRSCAN_PTR(ctx) ((ctx)->beg + (ctx)->pos)
#define STRSCAN_LEN(ctx) ((ctx)->end - STRSCAN_PTR(ctx))
#line 106 "detokenize.nw"
#line 320 "detokenize.nw"
#line 9 "strscan.nw"
struct strscan {
    char *beg, *end;
    int pos, fail;
};
#line 107 "detokenize.nw"
#line 324 "detokenize.nw"
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
#line 108 "detokenize.nw"
#line 160 "detokenize.nw"
int status = OK;        /* exit status of command, initially OK */
char *prog_name;        /* who we are */
long tot_line_count;    /* total number of lines */
#line 109 "detokenize.nw"
#line 322 "detokenize.nw"
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
#line 110 "detokenize.nw"
#line 92 "detokenize.nw"
int main(int argc, char **argv)
{
#line 37 "detokenize.nw"
    long input_line_number = 0;
#line 294 "detokenize.nw"
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
#line 95 "detokenize.nw"
#line 309 "detokenize.nw"
    prog_name = argv[0];
#line 96 "detokenize.nw"
#line 290 "detokenize.nw"
    file_count = argc - 1;
#line 97 "detokenize.nw"
#line 279 "detokenize.nw"
    argc--;
    do {
#line 260 "detokenize.nw"
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
#line 282 "detokenize.nw"
#line 255 "detokenize.nw"
        line_start = ptr = buffer;
        line_count = 0;
#line 283 "detokenize.nw"
#line 246 "detokenize.nw"
        line_start = ptr = buffer;
        nc = read(fd, ptr, BUF_SIZE);
        if (nc > 0) {
            buf_end = buffer + nc;
#line 216 "detokenize.nw"
            while (got_eof == 0) {
#line 174 "detokenize.nw"
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
#line 218 "detokenize.nw"
                c = *ptr++;
                if (c == '\n') {
                    /* lf or cr-lf */
            #if CONVERT_CRLF_TO_LF
                    ptr -= got_cr;
                    *(ptr - 1) = '\n';
            #endif
                    line_count++;
                    {
#line 41 "detokenize.nw"
#line 27 "detokenize.nw"
                        size_t line_length = ptr - line_start;
                        struct strscan ctx[1];
                        char *b;
#line 42 "detokenize.nw"
#line 19 "detokenize.nw"
                        if (line_length < 3) { /* CATEGORY RESERVED [ DATA ] LF */
                            fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                            exit(1);
                        }
                        line_length--;
#line 43 "detokenize.nw"
#line 33 "detokenize.nw"
                        strscan(ctx, line_start, line_length);
#line 44 "detokenize.nw"
                        b = ctx->beg;
                        switch (*b) {
                            case '0':
                                ctx->pos += 2;
                                fprintf(stderr, "file name: [");
                                fwrite(STRSCAN_PTR(ctx), 1, STRSCAN_LEN(ctx), stderr);
                                fprintf(stderr, "]\n");
                                input_line_number = 1;
                                break;
                            case '1':
                                putc('\n', stdout);
                                ctx->pos += 2;
                                fprintf(stderr, "done with line ");
                                fwrite(STRSCAN_PTR(ctx), 1, STRSCAN_LEN(ctx), stderr);
                                fprintf(stderr, " (%ld)\n", input_line_number);
                                input_line_number++;
                                break;
                            case '2': /* EOF */
                                break;
                            case '3': /* isalnum(c) || c == '_' */
                                ctx->pos += 2;
                                fwrite(STRSCAN_PTR(ctx), 1, STRSCAN_LEN(ctx), stdout);
                                break;
                            case '4': /* c == ' ' || c == '\t' */
                                ctx->pos += 2;
                                fwrite(STRSCAN_PTR(ctx), 1, STRSCAN_LEN(ctx), stdout);
                                break;
                            case '5': /* ispunct(c) */
                                putc(b[2], stdout);
                                break;
                            case '6': { /* c <= 127 */
                                    ctx->pos += 2;
                                    if (STRSCAN_LEN(ctx) != 2) {
                                        fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                                        exit(1);
                                    }
                                    c = (b[2] & ~0x40) << 4 | (b[3] & ~0x40);
                                    putc(c, stdout);
                                }
                                break;
                            default:
                                fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                                exit(1);
                                break;
                        }
#line 228 "detokenize.nw"
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
#line 251 "detokenize.nw"
        }
#line 284 "detokenize.nw"
#line 170 "detokenize.nw"
        close(fd);
#line 285 "detokenize.nw"
#line 166 "detokenize.nw"
        tot_line_count += line_count;
#line 286 "detokenize.nw"
    } while (--argc > 0);
#line 98 "detokenize.nw"
#line 313 "detokenize.nw"
    exit(status);
    return 0;
#line 99 "detokenize.nw"
}
