//
// Created by sap-1 on 17/01/2018.
//

#ifndef COMPI3_SYMBOLTABLES_H
#define COMPI3_SYMBOLTABLES_H

#include <iostream>
#include <vector>
#include <map>
#include <string>
#include "TableEntry.h"

#define ENTRY_SIZE 3

using namespace std;
typedef vector<TableEntry> Table;

class SymbolTables {
private:
    std::vector<Table>* tables;
    std::vector<int>* offset_vec;
    std::map<string, Table>* tables_map;
    int curr_offset;
public:
    SymbolTables();
    //~SymbolTables(){};
    string search(string);
    void makeTable();
    Table insert(string name, string type, int offset);
    void removeTable(); //remove the last table in the vector
    void print();
};



#endif //COMPI3_SYMBOLTABLES_H
