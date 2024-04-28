#line 130 "parse.nw"
#line 141 "parse.nw"
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
#line 131 "parse.nw"
#line 156 "parse.nw"
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <ctype.h>
#line 132 "parse.nw"
#line 178 "parse.nw"
#define OK                  0   /* status code for successful run */
#define CANNOT_OPEN_FILE    1   /* status code for file access error */
#define LINE_TOO_LONG       2   /* line longer than BUF_SIZE - 1 */
#define READ_ONLY           0   /* read access code for system open */
#line 170 "parse.nw"
#if BUFSIZ >= 512
#define BUF_SIZE            BUFSIZ
#else
#define BUF_SIZE            512
#endif
#line 183 "parse.nw"
#line 14 "parse.nw"
#define CONVERT_CRLF_TO_LF 1
#line 357 "parse.nw"
#line 32 "parse.nw"
#define TOKEN_QUEUE_SIZE 64
#line 16 "strscan.nw"
#define STRSCAN_PTR(ctx) ((ctx)->beg + (ctx)->pos)
#define STRSCAN_LEN(ctx) ((ctx)->end - STRSCAN_PTR(ctx))
#line 7 "queue.nw"
#define QUEUE_STRUCT(Q) ((struct queue*)(Q))
#define QUEUE_SIZE(Q) QUEUE_STRUCT(Q)->size
#define QUEUE_LENGTH(Q) QUEUE_STRUCT(Q)->tally
#line 84 "queue.nw"
#define SETUP_QUEUE(Q, S, T)    \
    (Q)->size = S;              \
    (Q)->tally = T;             \
    (Q)->mask = (S) - 1;        \
    (Q)->front = 0;             \
    (Q)->rear = T;
#line 93 "queue.nw"
#define SETUP_QUEUE_1(Q, A0) do {           \
        struct queue *__s__ = (Q).queue;    \
        void **__items__ = (Q).items_2;     \
        __items__[0] = A0;                  \
        SETUP_QUEUE(__s__, 2, 1);           \
    } while (0)
#define SETUP_QUEUE_2(Q, A0, A1) do {       \
        struct queue *__s__ = (Q).queue;    \
        void **__items__ = (Q).items_2;     \
        __items__[0] = A0;                  \
        __items__[1] = A1;                  \
        SETUP_QUEUE(__s__, 2, 2);           \
    } while (0)
#define SETUP_QUEUE_3(Q, A0, A1, A2) do {   \
        struct queue *__s__ = (Q).queue;    \
        void **__items__ = (Q).items_4;     \
        __items__[0] = A0;                  \
        __items__[1] = A1;                  \
        __items__[2] = A2;                  \
        SETUP_QUEUE(__s__, 4, 3);           \
    } while (0)
#define SETUP_QUEUE_4(Q, A0, A1, A2, A3) do {   \
        struct queue *__s__ = (Q).queue;        \
        void **__items__ = (Q).items_4;         \
        __items__[0] = A0;                      \
        __items__[1] = A1;                      \
        __items__[2] = A2;                      \
        __items__[3] = A3;                      \
        SETUP_QUEUE(__s__, 4, 4);               \
    } while (0)
#define SETUP_QUEUE_5(Q, A0, A1, A2, A3, A4) do {   \
        struct queue *__s__ = (Q).queue;            \
        void **__items__ = (Q).items_8;             \
        __items__[0] = A0;                          \
        __items__[1] = A1;                          \
        __items__[2] = A2;                          \
        __items__[3] = A3;                          \
        __items__[4] = A4;                          \
        SETUP_QUEUE(__s__, 8, 5);                   \
    } while (0)
#define SETUP_QUEUE_6(Q, A0, A1, A2, A3, A4, A5) do {   \
        struct queue *__s__ = (Q).queue;                \
        void **__items__ = (Q).items_8;                 \
        __items__[0] = A0;                              \
        __items__[1] = A1;                              \
        __items__[2] = A2;                              \
        __items__[3] = A3;                              \
        __items__[4] = A4;                              \
        __items__[5] = A5;                              \
        SETUP_QUEUE(__s__, 8, 6);                       \
    } while (0)
#define SETUP_QUEUE_7(Q, A0, A1, A2, A3, A4, A5, A6) do {   \
        struct queue *__s__ = (Q).queue;                    \
        void **__items__ = (Q).items_8;                     \
        __items__[0] = A0;                                  \
        __items__[1] = A1;                                  \
        __items__[2] = A2;                                  \
        __items__[3] = A3;                                  \
        __items__[4] = A4;                                  \
        __items__[5] = A5;                                  \
        __items__[6] = A6;                                  \
        SETUP_QUEUE(__s__, 8, 7);                           \
    } while (0)
#define SETUP_QUEUE_8(Q, A0, A1, A2, A3, A4, A5, A6, A7) do {   \
        struct queue *__s__ = (Q).queue;                        \
        void **__items__ = (Q).items_8;                         \
        __items__[0] = A0;                                      \
        __items__[1] = A1;                                      \
        __items__[2] = A2;                                      \
        __items__[3] = A3;                                      \
        __items__[4] = A4;                                      \
        __items__[5] = A5;                                      \
        __items__[6] = A6;                                      \
        __items__[7] = A7;                                      \
        SETUP_QUEUE(__s__, 8, 8);                               \
    } while (0)
#define SETUP_QUEUE_16(Q) setup_queue((Q).queue, (Q).items_16, 16)
#define SETUP_QUEUE_32(Q) setup_queue((Q).queue, (Q).items_32, 32)
#define SETUP_QUEUE_64(Q) setup_queue((Q).queue, (Q).items_64, 64)
#line 206 "queue.nw"
#define DECLARE_QUEUE_AND_ITEMS(Q,S,I)  \
    struct queue *S = Q;                \
    void **I = (void*)(S + 1)
#define ENQUEUE_NO_CHECK(S,I,V)         \
    do {                                \
        struct queue *__tmp__s = S;     \
        (I)[__tmp__s->rear] = V;        \
        __tmp__s->rear = (__tmp__s->rear + 1) & __tmp__s->mask; \
        __tmp__s->tally++;              \
    } while (0)
#define PUSH_FRONT_NO_CHECK(S,I,V)      \
    do {                                \
        struct queue *__tmp__s = S;     \
        __tmp__s->front = (__tmp__s->front - 1) & __tmp__s->mask; \
        (I)[__tmp__s->front] = V;       \
        __tmp__s->tally++;              \
    } while (0)
#define DEQUEUE_NO_CHECK(L,S,I)         \
    do {                                \
        struct queue *__tmp__s = S;     \
        L (I)[__tmp__s->front];         \
        __tmp__s->front = (__tmp__s->front + 1) & __tmp__s->mask; \
        __tmp__s->tally--;              \
    } while (0)
#define POP_REAR_NO_CHECK(S)            \
    do {                                \
        struct queue *__tmp__s = S;     \
        __tmp__s->rear = (__tmp__s->rear - 1) & __tmp__s->mask; \
        __tmp__s->tally--;              \
    } while (0)
#line 350 "queue.nw"
#define create_uint32(v) (void*)((uintptr_t)(v))
#define DEBUG_POINTER_NAME(PTR) debug_get_pointer_name(PTR)
#line 22 "reallocarray.nw"
/*
 * This is sqrt(SIZE_MAX+1), as s1*s2 <= SIZE_MAX
 * if both s1 < MUL_NO_OVERFLOW and s2 < MUL_NO_OVERFLOW
 */
#define MUL_NO_OVERFLOW ((size_t)1 << (sizeof(size_t) * 4))
#line 32 "tkscan.nw"
#define TKSCAN_PTR(ctx) ((ctx)->beg + (ctx)->pos)
#define TKSCAN_LEN(ctx) ((ctx)->end - TKSCAN_PTR(ctx))
#line 172 "tkscan.nw"
#define PEEK_TOKEN(Q, IDX) ((struct token*)peek_front(Q, IDX))
#line 133 "parse.nw"
#line 359 "parse.nw"
#line 9 "strscan.nw"
struct strscan {
    char *beg, *end;
    int pos, fail;
};
#line 13 "queue.nw"
struct queue {
    int size;
    int tally;
    unsigned int mask;
    unsigned int front;
    unsigned int rear;
};
#line 49 "queue.nw"
struct queue__check_alignment {
    struct queue queue[1];
    void *items[1];
};
struct queue_2 {
    struct queue queue[1];
    void *items_2[2];
};
struct queue_4 {
    struct queue queue[1];
    void *items_4[4];
};
struct queue_8 {
    struct queue queue[1];
    void *items_8[8];
};
struct queue_16 {
    struct queue queue[1];
    void *items_16[16];
};
struct queue_32 {
    struct queue queue[1];
    void *items_32[32];
};
struct queue_64 {
    struct queue queue[1];
    void *items_64[64];
};
#line 9 "tkscan.nw"
struct tkinfo_file_name {
    char *file_name;
};
struct tkinfo_line_number {
    struct tkinfo_file_name *file_name;
    int line_number;
};
struct token {
    struct tkinfo_line_number *line_number;
    char *image;
    int category;
    union tkvalue {
        char punct;     /* cat 5 */
        char hi_lo[2];  /* cat 6 (0x00..0xFF -> 0y@@..0yOO) */
    } value;
};
struct tkscan {
    struct queue *tokens;
    int needatleast;
};
#line 134 "parse.nw"
#line 363 "parse.nw"
#line 462 "parse.nw"
void consume_tokens(struct tkscan *ctx);
#line 21 "strscan.nw"
char *
strscan_strdup(struct strscan *ctx);
#line 41 "strscan.nw"
void
strscan(struct strscan *ctx, char *s, size_t len);
#line 57 "strscan.nw"
void rtrim(struct strscan *ctx);
#line 74 "strscan.nw"
int
startswith2(struct strscan *ctx, int x, int y);
#line 97 "strscan.nw"
int
endswith3(struct strscan *ctx, int x, int y, int z);
#line 120 "strscan.nw"
int
exact1(struct strscan *ctx, int x);
#line 143 "strscan.nw"
int
hasatleast(struct strscan *ctx, size_t len);
#line 23 "queue.nw"
struct queue *
new_queue(int size);
#line 175 "queue.nw"
void
setup_queue(struct queue *q, void **items, int size);
#line 195 "queue.nw"
void *
enqueue(struct queue *queue, void *v);
void *
dequeue(struct queue *queue);
void *
push_front(struct queue *queue, void *v);
void *
pop_rear(struct queue *queue);
#line 296 "queue.nw"
void *
peek_front(struct queue *queue, int pos);
#line 312 "queue.nw"
void
dequeue_discard(struct queue *queue, int howmany);
#line 328 "queue.nw"
void
queue_debug(struct queue *queue);
int
debug_set_pointer_name(void *ptr, char *name);
char *
debug_get_pointer_name(void *ptr);
#line 30 "reallocarray.nw"
void *
xreallocarray(void *optr, size_t nmemb, size_t size);
#line 37 "tkscan.nw"
void
tkscan(struct tkscan *ctx, struct queue *tokens);
#line 51 "tkscan.nw"
struct tkinfo_file_name *
new_tkinfo_file_name(struct strscan *ctx);
#line 67 "tkscan.nw"
struct tkinfo_line_number *
new_tkinfo_line_number(
    struct tkinfo_file_name *file_name,
    int line_number);
#line 94 "tkscan.nw"
struct token *
new_token_image(
    struct tkinfo_line_number *line_number,
    int category, struct strscan *ctx);
#line 114 "tkscan.nw"
struct token *
new_token_punct(
    struct tkinfo_line_number *line_number,
    int category, int punct);
#line 134 "tkscan.nw"
struct token *
new_token_hi_lo(
    struct tkinfo_line_number *line_number,
    int category, int hi, int lo);
#line 176 "tkscan.nw"
int
tkscan_startswith2(struct tkscan *ctx, int x, int y);
#line 135 "parse.nw"
#line 187 "parse.nw"
int status = OK;        /* exit status of command, initially OK */
char *prog_name;        /* who we are */
long tot_line_count;    /* total number of lines */
#line 365 "parse.nw"
static int so_far = 0;
static struct {
    struct {
        int size, tally;
        char **names;
        void **pointers;
    } pointers;
    char buf[100];
} g_debug_data = {0};
#line 136 "parse.nw"
#line 361 "parse.nw"
#line 466 "parse.nw"
void consume_tokens(struct tkscan *ctx)
{
    struct queue *q;
    struct token *token;

    q = ctx->tokens;

    /* token = dequeue(q); */
    token = PEEK_TOKEN(q, 0);
#line 437 "parse.nw"
    if (token->image) {
        printf("token category %d, line %d: [%s]\n",
            token->category, token->line_number->line_number,
            token->image);
    } else if (token->category == 5) {
        printf("token category %d, line %d: '%c'\n",
            token->category, token->line_number->line_number,
            token->value.punct);
    } else if (token->category == 6) {
        int c;
        char *hi_lo;
        hi_lo = token->value.hi_lo;
        /* 0x00..0xFF -> 0y@@..0yOO */
        /* 0xBF = ~0x40 & 0xFF */
        c = (hi_lo[0] & 0xBF) << 4 | (hi_lo[1] & 0xBF);
        printf("token category %d, line %d: 0x%02x (0y%c%c)\n",
            token->category, token->line_number->line_number,
            c, hi_lo[0], hi_lo[1]);
    } else {
        fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
        exit(1);
    }
#line 476 "parse.nw"

    switch (token->category) {
        case 3: /* isalnum(c) || c == '_' */
            /* bare word or number literal */
            dequeue(q);
            break;
        case 4: /* c == ' ' || c == '\t' */
            dequeue(q);
            break;
        case 5: /* ispunct(c) */
            dequeue(q);
            break;
        default:
            fprintf(stderr, "TRACE:%s:%i: step %i: " "exhaustion"
                "\n", __FILE__, (int)__LINE__ - 1, so_far++
                );
            if (so_far > 100) {
                fprintf(stderr, "Time is up Cinderella.\n");
                exit(1);
            }
            exit(1);
#line 490 "parse.nw"
            break;
    }
}

#line 26 "strscan.nw"
char *
strscan_strdup(struct strscan *ctx)
{
    char *res, *src;
    size_t len;
    src = STRSCAN_PTR(ctx);
    len = ctx->end - src;
    res = malloc(len + 1);
    memcpy(res, src, len);
    res[len] = '\0';
    return res;
}
#line 46 "strscan.nw"
void
strscan(struct strscan *ctx, char *s, size_t len)
{
    ctx->beg = s;
    ctx->end = s + len;
    ctx->pos = 0;
    ctx->fail = 0;
}
#line 61 "strscan.nw"
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
#line 79 "strscan.nw"
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
#line 102 "strscan.nw"
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
#line 125 "strscan.nw"
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
#line 148 "strscan.nw"
int
hasatleast(struct strscan *ctx, size_t len)
{
    if (ctx->fail) return 0;
    if ((ctx->end - (ctx->beg + ctx->pos)) >= (ssize_t)len) {
        return 1;
    }
    return 0;
}
#line 28 "queue.nw"
struct queue *
new_queue(int size)
{
    struct queue *res;
    if (size & (size - 1)) {
        fprintf(stderr, "Error, size must be a power of two.\n");
        exit(1);
    }
    res = calloc(1, sizeof(*res) + size * sizeof(void*));
    res->size = size;
    res->mask = size - 1;
    return res;
}
#line 180 "queue.nw"
void
setup_queue(struct queue *q, void **items, int size)
{
    struct queue__check_alignment *qca = (void*)q;
    q->size = size;
    q->tally = 0;
    q->front = q->rear = 0;
    q->mask = size - 1;
    if ((void*)(qca->items) != items) {
        fprintf(stderr, "TRACE:%s:%i: step %i: " "exhaustion"
            "\n", __FILE__, (int)__LINE__ - 1, so_far++
            );
        if (so_far > 100) {
            fprintf(stderr, "Time is up Cinderella.\n");
            exit(1);
        }
        exit(1);
#line 190 "queue.nw"
    }
}
#line 239 "queue.nw"
void *
enqueue(struct queue *queue, void *v)
{
    DECLARE_QUEUE_AND_ITEMS(queue, q, items);
    if (q->tally == q->size) {
        fprintf(stderr, "Error, queue is full.\n");
        exit(1);
    }
    ENQUEUE_NO_CHECK(q, items, v);
    return v;
}
#line 253 "queue.nw"
void *
dequeue(struct queue *queue)
{
    void *res;
    DECLARE_QUEUE_AND_ITEMS(queue, q, items);
    if (q->tally == 0) {
        fprintf(stderr, "Error, queue is empty.\n");
        exit(1);
    }
    DEQUEUE_NO_CHECK(res =, q, items);
    return res;
}
#line 268 "queue.nw"
void *
push_front(struct queue *queue, void *v)
{
    DECLARE_QUEUE_AND_ITEMS(queue, q, items);
    if (q->tally == q->size) {
        fprintf(stderr, "Error, queue is full.\n");
        exit(1);
    }
    PUSH_FRONT_NO_CHECK(q, items, v);
    return v;
}
#line 282 "queue.nw"
void *
pop_rear(struct queue *queue)
{
    DECLARE_QUEUE_AND_ITEMS(queue, q, items);
    if (q->tally == 0) {
        fprintf(stderr, "Error, queue is empty.\n");
        exit(1);
    }
    POP_REAR_NO_CHECK(q);
    return items[q->rear];
}
#line 301 "queue.nw"
void *
peek_front(struct queue *queue, int pos)
{
    unsigned int idx;
    DECLARE_QUEUE_AND_ITEMS(queue, q, items);
    idx = (q->front + pos) & q->mask;
    return items[idx];
}
#line 317 "queue.nw"
void
dequeue_discard(struct queue *queue, int howmany)
{
    while (howmany > 0) {
        howmany--;
        dequeue(queue);
    }
}
#line 333 "queue.nw"
void
queue_debug(struct queue *queue)
{
    struct queue *q = QUEUE_STRUCT(queue);
    unsigned int mask = q->size - 1;
    printf("**** queue debug: s=%i, t=%i, f=%i, r=%i, mask=0x%x\n",
        q->size, q->tally, q->front, q->rear, mask);
}
int
debug_set_pointer_name(void *ptr, char *name)
{
    int i;
    for (i = 0; i < g_debug_data.pointers.tally; ++i) {
        if (strcmp(g_debug_data.pointers.names[i], name) == 0) {
            g_debug_data.pointers.pointers[i] = ptr;
            return i;
        }
    }
    if (g_debug_data.pointers.size == 0) {
        g_debug_data.pointers.size = 64;
        g_debug_data.pointers.tally = 0;
        g_debug_data.pointers.names = calloc(g_debug_data.pointers.size, sizeof(char*));
        g_debug_data.pointers.pointers = calloc(g_debug_data.pointers.size, sizeof(void*));
    } else if (g_debug_data.pointers.tally == g_debug_data.pointers.size) {
        g_debug_data.pointers.size *= 2;
        g_debug_data.pointers.names = xreallocarray(g_debug_data.pointers.names, g_debug_data.pointers.size, sizeof(char*));
        g_debug_data.pointers.pointers = xreallocarray(g_debug_data.pointers.pointers, g_debug_data.pointers.size, sizeof(void*));
    }
    g_debug_data.pointers.names[g_debug_data.pointers.tally] = strdup(name);
    g_debug_data.pointers.pointers[g_debug_data.pointers.tally] = ptr;
    return g_debug_data.pointers.tally++;
}
char *
debug_get_pointer_name(void *ptr)
{
    int i;
    for (i = 0; i < g_debug_data.pointers.tally; ++i) {
        if (g_debug_data.pointers.pointers[i] == ptr) {
            return g_debug_data.pointers.names[i];
        }
    }
    snprintf(g_debug_data.buf, sizeof(g_debug_data.buf), "(unknown %p)", ptr);
    return g_debug_data.buf;
}
#line 35 "reallocarray.nw"
void *
xreallocarray(void *optr, size_t nmemb, size_t size)
{
    if ((nmemb >= MUL_NO_OVERFLOW || size >= MUL_NO_OVERFLOW) &&
        nmemb > 0 && SIZE_MAX / nmemb < size) {
        fprintf(stderr, "Error, cannot re-allocate array, size too large.");
        exit(1);
        /* errno = ENOMEM; */
        /* return NULL; */
    }
    return realloc(optr, size * nmemb);
}
#line 42 "tkscan.nw"
void
tkscan(struct tkscan *ctx, struct queue *tokens)
{
    ctx->tokens = tokens;
    ctx->needatleast = 0;
}
#line 56 "tkscan.nw"
struct tkinfo_file_name *
new_tkinfo_file_name(struct strscan *ctx)
{
    struct tkinfo_file_name *res;
    res = calloc(1, sizeof(*res));
    res->file_name = strscan_strdup(ctx);
    return res;
}
#line 74 "tkscan.nw"
struct tkinfo_line_number *
new_tkinfo_line_number(
    struct tkinfo_file_name *file_name,
    int line_number)
{
    struct tkinfo_line_number *res;
    res = calloc(1, sizeof(*res));
    res->file_name = file_name;
    res->line_number = line_number;
    return res;
}
#line 101 "tkscan.nw"
struct token *
new_token_image(
    struct tkinfo_line_number *line_number,
    int category, struct strscan *ctx)
{
    struct token *res;
#line 88 "tkscan.nw"
    res = calloc(1, sizeof(*res));
    res->line_number = line_number;
    res->category = category;
#line 108 "tkscan.nw"
    res->image = strscan_strdup(ctx);
    return res;
}
#line 121 "tkscan.nw"
struct token *
new_token_punct(
    struct tkinfo_line_number *line_number,
    int category, int punct)
{
    struct token *res;
#line 88 "tkscan.nw"
    res = calloc(1, sizeof(*res));
    res->line_number = line_number;
    res->category = category;
#line 128 "tkscan.nw"
    res->value.punct = punct;
    return res;
}
#line 141 "tkscan.nw"
struct token *
new_token_hi_lo(
    struct tkinfo_line_number *line_number,
    int category, int hi, int lo)
{
    struct token *res;
#line 88 "tkscan.nw"
    res = calloc(1, sizeof(*res));
    res->line_number = line_number;
    res->category = category;
#line 148 "tkscan.nw"
    res->value.hi_lo[0] = hi;
    res->value.hi_lo[1] = lo;
    return res;
}
#line 181 "tkscan.nw"
int
tkscan_startswith2(struct tkscan *ctx, int x, int y)
{
    struct queue *q;
    q = ctx->tokens;
    if (ctx->needatleast) return 0;
    if (q->tally < 2) {
        ctx->needatleast = 2;
        return 0;
    }
    if (PEEK_TOKEN(q, 0)->category == x && PEEK_TOKEN(q, 1)->category == y) {
        dequeue_discard(q, 2);
        return 1;
    }
    return 0;
}
#line 137 "parse.nw"
#line 119 "parse.nw"
int main(int argc, char **argv)
{
#line 26 "parse.nw"
    long input_line_number = 0;
    struct tkinfo_file_name *tkinfo_file_name = NULL;
    struct tkinfo_line_number *tkinfo_line_number = NULL;
#line 36 "parse.nw"
    struct queue_64 tokens;
#line 333 "parse.nw"
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
#line 122 "parse.nw"
#line 40 "parse.nw"
    SETUP_QUEUE_64(tokens);
#line 348 "parse.nw"
    prog_name = argv[0];
#line 367 "parse.nw"
    (void)so_far;
#line 123 "parse.nw"
#line 329 "parse.nw"
    file_count = argc - 1;
#line 124 "parse.nw"
#line 318 "parse.nw"
    argc--;
    do {
#line 299 "parse.nw"
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
#line 321 "parse.nw"
#line 294 "parse.nw"
        line_start = ptr = buffer;
        line_count = 0;
#line 322 "parse.nw"
#line 285 "parse.nw"
        line_start = ptr = buffer;
        nc = read(fd, ptr, BUF_SIZE);
        if (nc > 0) {
            buf_end = buffer + nc;
#line 243 "parse.nw"
            while (got_eof == 0) {
#line 201 "parse.nw"
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
#line 245 "parse.nw"
                c = *ptr++;
                if (c == '\n') {
                    /* lf or cr-lf */
            #if CONVERT_CRLF_TO_LF
                    ptr -= got_cr;
                    *(ptr - 1) = '\n';
            #endif
                    line_count++;
                    {
#line 59 "parse.nw"
#line 48 "parse.nw"
                        size_t line_length = ptr - line_start;
                        struct strscan ctx[1];
                        char *b;
                        struct token *token = NULL;
#line 60 "parse.nw"
#line 18 "parse.nw"
                        if (line_length < 3) { /* CATEGORY RESERVED [ DATA ] LF */
                            fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                            exit(1);
                        }
                        line_length--;
#line 61 "parse.nw"
#line 55 "parse.nw"
                        strscan(ctx, line_start, line_length);
#line 62 "parse.nw"
                        b = ctx->beg;
                        switch (*b) {
                            case '0':
                                ctx->pos += 2;
                                input_line_number = 1;
                                tkinfo_file_name = new_tkinfo_file_name(ctx);
                                tkinfo_line_number = new_tkinfo_line_number(tkinfo_file_name,
                                    input_line_number);
                                break;
                            case '1':
                                ctx->pos += 2;
                                input_line_number++;
                                tkinfo_line_number = new_tkinfo_line_number(tkinfo_file_name,
                                    input_line_number);
                                break;
                            case '2': /* EOF */
                                break;
                            case '3': /* isalnum(c) || c == '_' */
                                ctx->pos += 2;
                                token = new_token_image(tkinfo_line_number, 3, ctx);
                                break;
                            case '4': /* c == ' ' || c == '\t' */
                                ctx->pos += 2;
                                token = new_token_image(tkinfo_line_number, 4, ctx);
                                break;
                            case '5': /* ispunct(c) */
                                token = new_token_punct(tkinfo_line_number, 5, b[2]);
                                break;
                            case '6': { /* c <= 127 */
                                    ctx->pos += 2;
                                    if (STRSCAN_LEN(ctx) != 2) {
                                        fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                                        exit(1);
                                    }
                                    token = new_token_hi_lo(tkinfo_line_number, 6, b[2], b[3]);
                                }
                                break;
                            default:
                                fprintf(stderr, "Exhaustion %s:%d.", __FILE__, __LINE__);
                                exit(1);
                                break;
                        }
                        if (token) {
                            if (tokens.queue->tally >= TOKEN_QUEUE_SIZE) {
                                struct tkscan tkscan_ctx[1];
                                tkscan(tkscan_ctx, tokens.queue);
                                consume_tokens(tkscan_ctx);
                                if (tokens.queue->tally >= TOKEN_QUEUE_SIZE) {
                                    fprintf(stderr, "Error, parser is stuck, at %s:%d.", __FILE__, __LINE__);
                                    exit(1);
                                }
                            }
                            enqueue(tokens.queue, token);
                        }
#line 255 "parse.nw"
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
            {
                int tally;
                while ((tally = tokens.queue->tally)) {
                    struct tkscan tkscan_ctx[1];
                    tkscan(tkscan_ctx, tokens.queue);
                    consume_tokens(tkscan_ctx);
                    if (tally == tokens.queue->tally) {
                        fprintf(stderr, "Error, parser is stuck, at %s:%d.", __FILE__, __LINE__);
                        exit(1);
                    }
                }
            }
#line 290 "parse.nw"
        }
#line 323 "parse.nw"
#line 197 "parse.nw"
        close(fd);
#line 324 "parse.nw"
#line 193 "parse.nw"
        tot_line_count += line_count;
#line 325 "parse.nw"
    } while (--argc > 0);
#line 125 "parse.nw"
#line 352 "parse.nw"
    exit(status);
    return 0;
#line 126 "parse.nw"
}
