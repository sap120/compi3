//
// Created by sap-1 on 17/01/2018.
//

#ifndef COMPI3_SINGLETABLE_H
#define COMPI3_SINGLETABLE_H

#include <iostream>
#include <string>

using namespace std;

class TableEntry{
private:
    string name;
    string type;
    int offset;
public:
   TableEntry(string name, string type, int offset);
   const string get_name();
   const string get_type();
   const int get_offset();
   const void print();

};

#endif //COMPI3_SINGLETABLE_H
