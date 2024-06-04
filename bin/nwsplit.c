#line 112 "nwsplit.nw"
#line 123 "nwsplit.nw"
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
#line 113 "nwsplit.nw"
#line 138 "nwsplit.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <assert.h>
#line 114 "nwsplit.nw"
#line 160 "nwsplit.nw"
#define OK                  0   /* status code for successful run */
#define CANNOT_OPEN_FILE    1   /* status code for file access error */
#define LINE_TOO_LONG       2   /* line longer than BUF_SIZE - 1 */
#define READ_ONLY           0   /* read access code for system open */
#line 152 "nwsplit.nw"
#if BUFSIZ >= 512
#define BUF_SIZE            BUFSIZ
#else
#define BUF_SIZE            512
#endif
#line 165 "nwsplit.nw"
#line 11 "nwsplit.nw"
#define CONVERT_CRLF_TO_LF 1
#line 285 "nwsplit.nw"
#line 16 "strscan.nw"
#define STRSCAN_PTR(ctx) ((ctx)->beg + (ctx)->pos)
#define STRSCAN_LEN(ctx) ((size_t)((ctx)->end - STRSCAN_PTR(ctx)))
#line 115 "nwsplit.nw"
#line 287 "nwsplit.nw"
#line 9 "strscan.nw"
struct strscan {
    char *beg, *end;
    int pos, fail;
};
#line 116 "nwsplit.nw"
#line 291 "nwsplit.nw"
#line 52 "nwsplit.nw"
static int found_chunk(struct strscan *ctx);
#line 71 "nwsplit.nw"
static int found_end_of_chunk(struct strscan *ctx);
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
#line 117 "nwsplit.nw"
#line 169 "nwsplit.nw"
int status = OK;        /* exit status of command, initially OK */
char *prog_name;        /* who we are */
long tot_line_count;    /* total number of lines */
#line 118 "nwsplit.nw"
#line 289 "nwsplit.nw"
#line 56 "nwsplit.nw"
static int found_chunk(struct strscan *ctx)
{
    struct strscan save = *ctx;
    int res =
        startswith2(ctx, '<', '<') &&
        endswith3(ctx, '>', '>', '=') &&
        hasatleast(ctx, 1);
    if (!res) {
        *ctx = save;
    }
    return res;
}
#line 75 "nwsplit.nw"
static int found_end_of_chunk(struct strscan *ctx)
{
    return
        exact1(ctx, '@') ||
        startswith2(ctx, '@', ' ');
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
#line 119 "nwsplit.nw"
#line 101 "nwsplit.nw"
int main(int argc, char **argv)
{
#line 47 "nwsplit.nw"
    int inside_chunk = 0;
    long id = 0;
#line 261 "nwsplit.nw"
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
#line 104 "nwsplit.nw"
#line 276 "nwsplit.nw"
    prog_name = argv[0];
#line 105 "nwsplit.nw"
#line 257 "nwsplit.nw"
    file_count = argc - 1;
#line 106 "nwsplit.nw"
#line 246 "nwsplit.nw"
    argc--;
    do {
#line 227 "nwsplit.nw"
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
#line 249 "nwsplit.nw"
#line 222 "nwsplit.nw"
        line_start = line_end = buffer;
        line_count = 0;
#line 250 "nwsplit.nw"
#line 213 "nwsplit.nw"
        line_start = line_end = buffer;
        nc = read(fd, line_end, BUF_SIZE);
        if (nc > 0) {
            buf_end = buffer + nc;
#line 183 "nwsplit.nw"
            while (got_eof == 0) {
#line 2 "nwsplit--imports.nw"
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
#line 185 "nwsplit.nw"
                c = *line_end++;
                if (c == '\n') {
                    /* lf or cr-lf */
            #if CONVERT_CRLF_TO_LF
                    line_end -= got_cr;
                    *(line_end - 1) = '\n';
            #endif
                    line_count++;
                    {
#line 15 "nwsplit.nw"
#line 92 "nwsplit.nw"
                        size_t line_length;
                        struct strscan ctx[1];
#line 16 "nwsplit.nw"
                        assert(line_end >= line_start);
                        line_length = (size_t)(line_end - line_start);
#line 84 "nwsplit.nw"
                        if (line_length == 0) {
                            fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                            exit(1);
                        }
                        line_length--;
#line 19 "nwsplit.nw"
#line 97 "nwsplit.nw"
                        strscan(ctx, line_start, line_length);
#line 20 "nwsplit.nw"
                        if (found_chunk(ctx)) {
                            inside_chunk = 1;
                            fprintf(stdout, "%08lx_1: ", ++id);
                            fwrite(line_start, 1, line_length, stdout);
                            fprintf(stdout, "\n");
                        } else if (inside_chunk) {
                            if (found_end_of_chunk(ctx)) {
                                inside_chunk = 0;
                                fprintf(stdout, "%08lx_3: ", id++);
                                fwrite(line_start, 1, line_length, stdout);
                                fprintf(stdout, "\n");
                            } else {
                                if (startswith2(ctx, '@', '@')) {
                                    ctx->pos--;
                                }
                                fprintf(stdout, "%08lx_2: ", id);
                                fwrite(STRSCAN_PTR(ctx), 1, STRSCAN_LEN(ctx), stdout);
                                fprintf(stdout, "\n");
                            }
                        } else {
                            fprintf(stdout, "%08lx_0: ", id);
                            fwrite(line_start, 1, line_length, stdout);
                            fprintf(stdout, "\n");
                        }
#line 195 "nwsplit.nw"
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
#line 218 "nwsplit.nw"
        }
#line 251 "nwsplit.nw"
#line 179 "nwsplit.nw"
        close(fd);
#line 252 "nwsplit.nw"
#line 175 "nwsplit.nw"
        tot_line_count += line_count;
#line 253 "nwsplit.nw"
    } while (--argc > 0);
#line 107 "nwsplit.nw"
#line 280 "nwsplit.nw"
    exit(status);
    return 0;
#line 108 "nwsplit.nw"
}
