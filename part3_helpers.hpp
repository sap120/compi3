/* 046266 Compilation Methods, EE Faculty, Technion                        */
/* part2_helpers.h - Helper functions for project part 2 - API definitions */

#ifndef COMMON_H
#define COMMON_H
#include <cstdlib>
#include <cstring>
#include <string>
#include <list>
#include <vector>
#define YYSTYPE PparserNode

#ifdef __cplusplus
extern "C" {
#endif

using namespace std;

std::vector<std::string> cmd_seq;

typedef struct node {
    char *type;
    char *value;
    std::list<int> trueList;
    std::list<int> falseList;
    std::list<int> nextList;
    int quad;
    struct node *sibling;
    struct node *child;
} ParserNode, *PparserNode;

ParserNode *makeNode(const char *type, const char *value, ParserNode *child);

ParserNode *concatList(ParserNode *listHead, ParserNode *newItem);

void dumpParseTree(void);

void emit(std::string);

int newtemp();

#ifdef __cplusplus
}// extern "C"
#endif

#endif //COMMON_H
