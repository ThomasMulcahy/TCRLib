#include "view.h"
#include <stdlib.h>
#include <string.h>

void *getData(ViewData *data, char *key) {
    if (data == NULL)
        return NULL;

    if (data->values == NULL)
        return NULL;

    KeyValue *pair = data->values;
    while (pair != NULL) {
        if (strcmp(pair->key, key) == 0) {
            return pair->value;
        }
    }
    return NULL;
}

void addData(ViewData *data, char *key, void *value) {
    KeyValue *pair = malloc(sizeof(KeyValue));
    pair->key = key;
    pair->value = value;

    if (data->values != NULL) {
        pair->next = data->values;
        data->values = pair;
    } else {
        data->values = pair;
    }
}