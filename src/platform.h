#ifndef PLATFORM_H
#define PLATFORM_H

#include "view.h"

typedef struct _WindowOpt {
    char *title;
    int width;
    int height;
} WindowOpt;

int platformRun(WindowOpt *winOptions, View *view);

#endif