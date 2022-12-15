-- Copyright (C) 2022 Theros < MisModding | SvalTek >
-- 
-- This file is part of RayBricks.
-- 
-- RayBricks is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- RayBricks is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with RayBricks.  If not, see <http://www.gnu.org/licenses/>.
---@meta raylib-lua-sol FileManagement

--[[
    Files management functions

    unsigned char *LoadFileData(const char *fileName, unsigned int *bytesRead);       // Load file data as byte array (read)
    void UnloadFileData(unsigned char *data);                   // Unload file data allocated by LoadFileData()
    bool SaveFileData(const char *fileName, void *data, unsigned int bytesToWrite);   // Save data to file from byte array (write), returns true on success
    bool ExportDataAsCode(const char *data, unsigned int size, const char *fileName); // Export data to code (.h), returns true on success
    char *LoadFileText(const char *fileName);                   // Load text data from file (read), returns a '\0' terminated string
    void UnloadFileText(char *text);                            // Unload file text data allocated by LoadFileText()
    bool SaveFileText(const char *fileName, char *text);        // Save text data to file (write), string must be '\0' terminated, returns true on success
    bool FileExists(const char *fileName);                      // Check if file exists
    bool DirectoryExists(const char *dirPath);                  // Check if a directory path exists
    bool IsFileExtension(const char *fileName, const char *ext); // Check file extension (including point: .png, .wav)
    int GetFileLength(const char *fileName);                    // Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)
    const char *GetFileExtension(const char *fileName);         // Get pointer to extension for a filename string (includes dot: '.png')
    const char *GetFileName(const char *filePath);              // Get pointer to filename for a path string
    const char *GetFileNameWithoutExt(const char *filePath);    // Get filename string without extension (uses static string)
    const char *GetDirectoryPath(const char *filePath);         // Get full path for a given fileName with path (uses static string)
    const char *GetPrevDirectoryPath(const char *dirPath);      // Get previous directory path for a given path (uses static string)
    const char *GetWorkingDirectory(void);                      // Get current working directory (uses static string)
    const char *GetApplicationDirectory(void);                  // Get the directory if the running application (uses static string)
    bool ChangeDirectory(const char *dir);                      // Change working directory, return true on success
    bool IsPathFile(const char *path);                          // Check if a given path is a file or a directory
    FilePathList LoadDirectoryFiles(const char *dirPath);       // Load directory filepaths
    FilePathList LoadDirectoryFilesEx(const char *basePath, const char *filter, bool scanSubdirs); // Load directory filepaths with extension filtering and recursive directory scan
    void UnloadDirectoryFiles(FilePathList files);              // Unload filepaths
    bool IsFileDropped(void);                                   // Check if a file has been dropped into window
    FilePathList LoadDroppedFiles(void);                        // Load dropped filepaths
    void UnloadDroppedFiles(FilePathList files);                // Unload dropped filepaths
    long GetFileModTime(const char *fileName);                  // Get file modification time (last write time)
    
    Compression/Encoding functionality

    unsigned char *CompressData(const unsigned char *data, int dataSize, int *compDataSize);        // Compress data (DEFLATE algorithm), memory must be MemFree()
    unsigned char *DecompressData(const unsigned char *compData, int compDataSize, int *dataSize);  // Decompress data (DEFLATE algorithm), memory must be MemFree()
    char *EncodeDataBase64(const unsigned char *data, int dataSize, int *outputSize);               // Encode data to Base64 string, memory must be MemFree()
    unsigned char *DecodeDataBase64(const unsigned char *data, int *outputSize);       
]]


---@alias FilePathList string[]
---@alias FileData any


--- Load file data as byte array (read)
---@param fileName string
---@param bytesRead number
---@return any
function LoadFileData(fileName, bytesRead) end

--- Unload file data allocated by LoadFileData()
---@param data any
function UnloadFileData(data) end

--- Save data to file from byte array (write), returns true on success
---@param fileName string
---@param data any
---@param bytesToWrite number
---@return boolean
function SaveFileData(fileName, data, bytesToWrite) end

--- Export data to code (.h), returns true on success
---@param data string
---@param size number
---@param fileName string
---@return boolean
function ExportDataAsCode(data, size, fileName) end

--- Load text data from file (read), returns a '\0' terminated string
---@param fileName string
---@return string
function LoadFileText(fileName) end

--- Unload file text data allocated by LoadFileText()
---@param text string
function UnloadFileText(text) end

--- Save text data to file (write), string must be '\0' terminated, returns true on success
---@param fileName string
---@param text string
---@return boolean
function SaveFileText(fileName, text) end

--- Check if file exists
---@param fileName string
---@return boolean
function FileExists(fileName) end

--- Check if a directory path exists
---@param dirPath string
---@return boolean
function DirectoryExists(dirPath) end

--- Check file extension (including point: .png, .wav)
---@param fileName string
---@param ext string
---@return boolean
function IsFileExtension(fileName, ext) end

--- Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)
---@param fileName string
---@return number
function GetFileLength(fileName) end

--- Get pointer to extension for a filename string (includes dot: '.png')
---@param fileName string
---@return string
function GetFileExtension(fileName) end

--- Get pointer to filename for a path string
---@param filePath string
---@return string
function GetFileName(filePath) end

--- Get filename string without extension (uses static string)
---@param filePath string
---@return string
function GetFileNameWithoutExt(filePath) end

--- Get full path for a given fileName with path (uses static string)
---@param filePath string
---@return string
function GetDirectoryPath(filePath) end

--- Get previous directory path for a given path (uses static string)
---@param dirPath string
---@return string
function GetPrevDirectoryPath(dirPath) end

--- Get current working directory (uses static string)
---@return string
function GetWorkingDirectory() end

--- Get the directory if the running application (uses static string)
---@return string
function GetApplicationDirectory() end

--- Change working directory, return true on success
---@param dir string
---@return boolean
function ChangeDirectory(dir) end

--- Check if a given path is a file or a directory
---@param path string
---@return boolean
function IsPathFile(path) end

--- Load directory filepaths
---@param dirPath string
---@return FilePathList
function LoadDirectoryFiles(dirPath) end

--- Load directory filepaths with extension filtering and recursive directory scan
---@param basePath string
---@param filter string
---@param scanSubdirs boolean
---@return FilePathList
function LoadDirectoryFilesEx(basePath, filter, scanSubdirs) end

--- Unload filepaths
---@param files FilePathList
function UnloadDirectoryFiles(files) end

--- Check if a file has been dropped into window
---@return boolean
function IsFileDropped() end

--- Load dropped filepaths
---@return FilePathList
function LoadDroppedFiles() end

--- Unload dropped filepaths
---@param files FilePathList
function UnloadDroppedFiles(files) end

--- Get file modification time (last write time)
---@param fileName string
---@return number
function GetFileModTime(fileName) end

--- Compress data (DEFLATE algorithm), memory must be MemFree()
---@param data any
---@param dataSize? number
---@param compDataSize? number
---@return any
function CompressData(data, dataSize, compDataSize) end

--- Decompress data (DEFLATE algorithm), memory must be MemFree()
---@param compData any
---@param compDataSize? number
---@param dataSize? number
---@return any
function DecompressData(compData, compDataSize, dataSize) end

--- Encode data to Base64 string (MIME encoding), memory must be MemFree()
---@param data any
---@param dataSize? number
---@param outputSize? number
---@return string
function EncodeDataBase64(data, dataSize, outputSize) end

--- Decode data from Base64 string (MIME encoding), memory must be MemFree()
---@param data string
---@param outputSize? number
---@return any
function DecodeDataBase64(data, outputSize) end
