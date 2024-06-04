#line 111 "detokenize.nw"
#line 122 "detokenize.nw"
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
#line 112 "detokenize.nw"
#line 137 "detokenize.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <assert.h>
#line 113 "detokenize.nw"
#line 159 "detokenize.nw"
#define OK                  0   /* status code for successful run */
#define CANNOT_OPEN_FILE    1   /* status code for file access error */
#define LINE_TOO_LONG       2   /* line longer than BUF_SIZE - 1 */
#define READ_ONLY           0   /* read access code for system open */
#line 151 "detokenize.nw"
#if BUFSIZ >= 512
#define BUF_SIZE            BUFSIZ
#else
#define BUF_SIZE            512
#endif
#line 164 "detokenize.nw"
#line 15 "detokenize.nw"
#define CONVERT_CRLF_TO_LF 1
#line 284 "detokenize.nw"
#line 16 "strscan.nw"
#define STRSCAN_PTR(ctx) ((ctx)->beg + (ctx)->pos)
#define STRSCAN_LEN(ctx) ((size_t)((ctx)->end - STRSCAN_PTR(ctx)))
#line 114 "detokenize.nw"
#line 286 "detokenize.nw"
#line 9 "strscan.nw"
struct strscan {
    char *beg, *end;
    int pos, fail;
};
#line 115 "detokenize.nw"
#line 290 "detokenize.nw"
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
#line 116 "detokenize.nw"
#line 168 "detokenize.nw"
int status = OK;        /* exit status of command, initially OK */
char *prog_name;        /* who we are */
long tot_line_count;    /* total number of lines */
#line 117 "detokenize.nw"
#line 288 "detokenize.nw"
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
#line 118 "detokenize.nw"
#line 100 "detokenize.nw"
int main(int argc, char **argv)
{
#line 37 "detokenize.nw"
    long input_line_number = 0;
#line 260 "detokenize.nw"
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
#line 103 "detokenize.nw"
#line 275 "detokenize.nw"
    prog_name = argv[0];
#line 104 "detokenize.nw"
#line 256 "detokenize.nw"
    file_count = argc - 1;
#line 105 "detokenize.nw"
#line 245 "detokenize.nw"
    argc--;
    do {
#line 226 "detokenize.nw"
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
#line 248 "detokenize.nw"
#line 221 "detokenize.nw"
        line_start = line_end = buffer;
        line_count = 0;
#line 249 "detokenize.nw"
#line 212 "detokenize.nw"
        line_start = line_end = buffer;
        nc = read(fd, line_end, BUF_SIZE);
        if (nc > 0) {
            buf_end = buffer + nc;
#line 182 "detokenize.nw"
            while (got_eof == 0) {
#line 2 "detokenize--imports.nw"
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
#line 184 "detokenize.nw"
                c = *line_end++;
                if (c == '\n') {
                    /* lf or cr-lf */
            #if CONVERT_CRLF_TO_LF
                    line_end -= got_cr;
                    *(line_end - 1) = '\n';
            #endif
                    line_count++;
                    {
#line 41 "detokenize.nw"
#line 27 "detokenize.nw"
                        size_t line_length;
                        struct strscan ctx[1];
                        char *b;
#line 42 "detokenize.nw"
                        assert(line_end >= line_start);
                        line_length = (size_t)(line_end - line_start);
#line 19 "detokenize.nw"
                        if (line_length < 3) { /* CATEGORY RESERVED [ DATA ] LF */
                            fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                            exit(1);
                        }
                        line_length--;
#line 45 "detokenize.nw"
#line 33 "detokenize.nw"
                        strscan(ctx, line_start, line_length);
#line 46 "detokenize.nw"
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
                            case '3': /* isalpha(c) */
                                ctx->pos += 2;
                                fwrite(STRSCAN_PTR(ctx), 1, STRSCAN_LEN(ctx), stdout);
                                break;
                            case '4': /* isdigit(c) */
                                ctx->pos += 2;
                                fwrite(STRSCAN_PTR(ctx), 1, STRSCAN_LEN(ctx), stdout);
                                break;
                            case '5': /* c == ' ' || c == '\t' */
                                ctx->pos += 2;
                                fwrite(STRSCAN_PTR(ctx), 1, STRSCAN_LEN(ctx), stdout);
                                break;
                            case '6': /* ispunct(c) */
                                putc(b[2], stdout);
                                break;
                            case '7': { /* c <= 127 */
                                    ctx->pos += 2;
                                    if (STRSCAN_LEN(ctx) != 2) {
                                        fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                                        exit(1);
                                    }
                                    /* 0x00..0xFF -> 0y@@..0yOO */
                                    /* 0xBF = ~0x40 & 0xFF */
                                    c = (b[2] & 0xBF) << 4 | (b[3] & 0xBF);
                                    putc(c, stdout);
                                }
                                break;
                            default:
                                fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                                exit(1);
                                break;
                        }
#line 194 "detokenize.nw"
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
#line 217 "detokenize.nw"
        }
#line 250 "detokenize.nw"
#line 178 "detokenize.nw"
        close(fd);
#line 251 "detokenize.nw"
#line 174 "detokenize.nw"
        tot_line_count += line_count;
#line 252 "detokenize.nw"
    } while (--argc > 0);
#line 106 "detokenize.nw"
#line 279 "detokenize.nw"
    exit(status);
    return 0;
#line 107 "detokenize.nw"
}
