

#include "SymbolTables.h"


SymbolTables::SymbolTables() {
    tables =new vector<Table>;
    offset_vec = new vector<int>;
    tables_map = new std::map<std::string, Table>;
    curr_offset = 0;
}

void SymbolTables::makeTable() {
    Table new_table;
    offset_vec->push_back(curr_offset);
    tables->push_back(new_table);
}

Table SymbolTables::insert(string name, string type, int offset) {
    TableEntry new_entry(name, type, offset);
    try {
        tables->back().push_back(new_entry);
    }
    catch(...){
        cerr << "No Tables Found" << endl;
    }
    tables_map->insert(std::pair<string, Table>(name, tables->back()));
    curr_offset += offset;
    return tables->back();
}

/*returns the symbol's type if found, otherwise NULL*/
string SymbolTables::search(string name) {
    map<string, Table>::iterator elem = tables_map->find(name);
    if (elem == tables_map->end())
        return "NULL";
    Table t = elem->second;
    for (vector<TableEntry>::iterator it = t.begin(); it != t.end(); it++){
        if ((*(it)).get_name() == name)
            return (*it).get_type();
    }
}

void SymbolTables:: removeTable(){
    tables->pop_back();
}

void SymbolTables::print() {
    int i = 0;
    for (vector<Table>::iterator it = tables->begin(); it != tables->end(); it++) {
        int off;
        off = (*(offset_vec))[i];
        cout << "curr table offset: " << off << endl;
        i++;
        for (Table::iterator iter = it->begin(); iter != it->end(); iter++) {
            iter->print();
        }
    }
}



/*TEST*/
int main(){
    SymbolTables myTable;
    myTable.makeTable();
    myTable.insert("first", "int", 0);
    myTable.insert("second", "char", sizeof(int));
    myTable.insert("third", "bool", 0);
    myTable.makeTable();
    myTable.insert("first2", "char", 24);
    myTable.print();
    cout << "first type is " << myTable.search("first") << endl;
    return 0;
}