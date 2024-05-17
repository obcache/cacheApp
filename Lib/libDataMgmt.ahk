;SQLite Functions
;SQLiteSelectData(<byRef Array for Return Data>,<SQLite3 Query>,<SQLite3 Database Path+Filename>)
;SQLiteInsertData(<Array of Data to Insert>,<Table Name>,<SQLite3 Database Path+Filename>)
;SQLiteUpdateData(<Array of Updated Data>,<Table Name>,<Condition>,<SQLite3 Database Path+Filename>)

;JSON Functions
;SelectDataFromJSON(<byRef Array for Return Data>,<JSON Path+Filename>)
;InsertDataIntoJSON(<Array of Data to Insert>,<JSON Path+Filename>)
;UpdateDataInJSON(<Array of Updated Data>,<IndeX>,<JSON Path+Filename>)


#requires autoHotkey v2.0+
#singleInstance
#warn all,off

SQLiteDLL := "./redist/sqlite3.dll"

SQLiteSelectData(&resultArray, query, dbName) {
    sqlite3 := DllCall("LoadLibrary", "str", "./redist/sqlite3.dll", "Ptr")
    db := 0
	DllCall(".\redist\sqlite3.dll\sqlite3_open", "str",dbname,"PtrP", &db)
    stmt := 0

    err := DllCall(".\redist\sqlite3.dll\sqlite3_prepare_v2", "ptrP", db, "str", query, "Int", -1, "PtrP", &stmt, "ptr",  0)
		msgBox(db "`n" stmt)
    resultArray := []
    Loop {
        err := DllCall(".\redist\sqlite3.dll\sqlite3_step", "ptr", stmt, "Int")
       msgBox(stmt)
	   if (err != 100)  ; SQLITE_ROW
            break
        row := []
        cols := DllCall(".\redist\sqlite3.dll\sqlite3_column_count", "ptr", stmt, "Int")
      				msgBox(db "`n" cols "`n" stmt)
					Loop cols {
            colType := DllCall(".\redist\sqlite3.dll\sqlite3_column_type", "ptr", stmt, "Int", A_Index - 1, "Int")
            if (colType = 1)  ; SQLITE_INTEGER
                value := DllCall(".\redist\sqlite3.dll\sqlite3_column_int", "ptr", stmt, "Int", A_Index - 1, "Int")
            else if (colType = 2)  ; SQLITE_FLOAT
                value := DllCall(".\redist\sqlite3.dll\sqlite3_column_double", "ptr", stmt, "Int", A_Index - 1, "CDouble")
            else
                value := DllCall(".\redist\sqlite3.dll\sqlite3_column_text", "ptr", stmt, "Int", A_Index - 1, "PtrP", 0, "PtrP", 0)
				row.Push(value)

        }
        resultArray.Push(row)
		
    }
    DllCall(".\redist\sqlite3.dll\sqlite3_finalize", "ptr", stmt)
    DllCall(".\redist\sqlite3.dll\sqlite3_close", "ptrP", &db)
    DllCall("FreeLibrary", "ptr", sqlite3)
}

SQLiteQuery(dataArray, query, dbName) {
    sqlite3 := DllCall("LoadLibrary", "str", "sqlite3.dll", "Ptr")
    VarSetCapacity(db, 4)
    DllCall(".\redist\sqlite3.dll\sqlite3_open", "str", dbName, "PtrP", &db)
    DllCall(".\redist\sqlite3.dll\sqlite3_exec", "ptr", &db, "str", query, "ptr", 0, "ptr", 0, "PtrP", 0)
    DllCall(".\redist\sqlite3.dll\sqlite3_close", "ptr", &db)
    DllCall("FreeLibrary", "ptr", sqlite3)
}

SQLiteInsertData(dataArray, tableName, dbName) {
    sqlite3 := DllCall("LoadLibrary", "str", "sqlite3.dll", "Ptr")
    VarSetCapacity(db, 4)
    DllCall(".\redist\sqlite3.dll\sqlite3_open", "str", dbName, "PtrP", &db)
    query := "INSERT INTO " . tableName . " VALUES ("
    Loop dataArray.MaxIndex() {
        value := dataArray[A_Index]
        if (IsObject(value))
            value := value.0
        query .= (A_Index > 1 ? ", " : "") . (IsObject(value) ? "'" . value . "'" : value)
    }
    query .= ")"
    DllCall(".\redist\sqlite3.dll\sqlite3_exec", "ptr", &db, "str", query, "ptr", 0, "ptr", 0, "PtrP", 0)
    DllCall(".\redist\sqlite3.dll\sqlite3_close", "ptr", &db)
    DllCall("FreeLibrary", "ptr", sqlite3)
}

SQLiteUpdateData(dataArray, tableName, condition, dbName) {
    sqlite3 := DllCall("LoadLibrary", "str", "sqlite3.dll", "Ptr")
    VarSetCapacity(db, 4)
    DllCall(".\redist\sqlite3.dll\sqlite3_open", "str", dbName, "PtrP", &db)
    query := "UPDATE " . tableName . " SET "
    Loop dataArray.MaxIndex() {
        col := dataArray[A_Index]
        if (IsObject(col)) {
            colName := col.0
            colValue := col.1
            query .= (A_Index > 1 ? ", " : "") . colName . " = " . (IsObject(colValue) ? "'" . colValue . "'" : colValue)
        }
    }
    query .= " WHERE " . condition
    DllCall(".\redist\sqlite3.dll\sqlite3_exec", "ptr", &db, "str", query, "ptr", 0, "ptr", 0, "PtrP", 0)
    DllCall(".\redist\sqlite3.dll\sqlite3_close", "ptr", &db)
    DllCall("FreeLibrary", "ptr", sqlite3)
}

SelectDataFromJSON(&resultArray, filePath) {
    FileRead(jsonData,filePath)
    resultArray := []
    resultArray := JsonLoad(jsonData)
}

InsertDataIntoJSON(dataArray, filePath) {
    FileRead(jsonData,filePath)
    data := JsonLoad(jsonData)
    data.Push(dataArray)
    json := JsonDump(data)
    FileDelete(filePath)
    FileAppend(json,filePath)
}

UpdateDataInJSON(dataArray, index, filePath) {
    FileRead(jsonData,filePath)
    data := JsonLoad(jsonData)
    Loop dataArray.MaxIndex() {
        col := dataArray[A_Index]
        if (IsObject(col)) {
            colName := col.0
            colValue := col.1
            data[index][colName] := colValue
        }
    }
    json := JsonDump(data)
    FileDelete(filePath)
    FileAppend(json,filePath)
}
