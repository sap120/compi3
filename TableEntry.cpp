//
// Created by sap-1 on 17/01/2018.
//

#include "TableEntry.h"

TableEntry::TableEntry(string name, string type, int offset) :name(name), type(type), offset(offset){}

const string TableEntry::get_name() {
    return name;
}

const int TableEntry::get_offset() {
    return offset;
}

const string TableEntry::get_type() {
    return type;
}

const void TableEntry::print() {
    cout << "Name: " << name << " Type: " << type << " offset: " << offset << endl;
}