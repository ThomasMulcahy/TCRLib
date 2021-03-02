#ifndef VIEW_H
#define VIEW_H

#include <stdio.h>
#include <stdlib.h>

typedef enum _ViewEventKind {
    KEY_DOWN_EVENT,
    MOUSE_UP_EVENT
} ViewEventKind;

typedef struct _ViewEvent {
    ViewEventKind eventKind;

    //Keydown Event
    char code;

    //Mouse related events
    int mouseX;
    int mouseY;
} ViewEvent;

typedef struct _KeyValue {
    char *key;
    void *value;

    //Linked list
    struct _KeyValue *next;
} KeyValue;

/**
 * Used to pass data to other functions which the View interacts with,
 * use this for custom data.
 * 
 * This uses key/value pairs to gain access to memory.
 *
 * Use the provided helper functions to access this data, don't forget to cast
 * the result.
 */
typedef struct _ViewData {
    KeyValue *values;
} ViewData;

typedef struct _View {
    ViewData *data;

    void (*onCreate)(ViewData*);
    void (*onViewEvent)(ViewData*, ViewEvent);
    void (*onDraw)(ViewData *);
    void (*onViewDestroy)(ViewData*);

} View;

/**
 * Warning: This can return NULL, so check before using pointer.
 */
void *getData(ViewData *data, char *key);

void addData(ViewData *data, char *key, void *value);

#endif
