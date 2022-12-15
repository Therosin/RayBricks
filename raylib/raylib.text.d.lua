-- Copyright (C) 2022 Theros < MisModding | SvalTek >
-- 
-- This file is part of RayBricks.
-- 
-- RayBricks is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- RayBricks is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General License for more details.
-- 
-- You should have received a copy of the GNU General License
-- along with RayBricks.  If not, see <http://www.gnu.org/licenses/>.
---@meta raylib-lua-sol text
--[[
     // Font loading/unloading functions
    Font GetFontDefault(void);                                                            // Get the default Font
    Font LoadFont(const char *fileName);                                                  // Load font from file into GPU memory (VRAM)
    Font LoadFontEx(const char *fileName, int fontSize, int *fontChars, int glyphCount);  // Load font from file with extended parameters, use NULL for fontChars and 0 for glyphCount to load the default character set
    Font LoadFontFromImage(Image image, Color key, int firstChar);                        // Load font from Image (XNA style)
    Font LoadFontFromMemory(const char *fileType, const unsigned char *fileData, int dataSize, int fontSize, int *fontChars, int glyphCount); // Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
    GlyphInfo *LoadFontData(const unsigned char *fileData, int dataSize, int fontSize, int *fontChars, int glyphCount, int type); // Load font data for further use
    Image GenImageFontAtlas(const GlyphInfo *chars, Rectangle **recs, int glyphCount, int fontSize, int padding, int packMethod); // Generate image font atlas using chars info
    void UnloadFontData(GlyphInfo *chars, int glyphCount);                                // Unload font chars info data (RAM)
    void UnloadFont(Font font);                                                           // Unload font from GPU memory (VRAM)
    bool ExportFontAsCode(Font font, const char *fileName);                               // Export font as code file, returns true on success

    // Text drawing functions
    void DrawFPS(int posX, int posY);                                                     // Draw current FPS
    void DrawText(const char *text, int posX, int posY, int fontSize, Color color);       // Draw text (using default font)
    void DrawTextEx(Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint); // Draw text using font and additional parameters
    void DrawTextPro(Font font, const char *text, Vector2 position, Vector2 origin, float rotation, float fontSize, float spacing, Color tint); // Draw text using Font and pro parameters (rotation)
    void DrawTextCodepoint(Font font, int codepoint, Vector2 position, float fontSize, Color tint); // Draw one character (codepoint)
    void DrawTextCodepoints(Font font, const int *codepoints, int count, Vector2 position, float fontSize, float spacing, Color tint); // Draw multiple character (codepoint)

    // Text font info functions
    int MeasureText(const char *text, int fontSize);                                      // Measure string width for default font
    Vector2 MeasureTextEx(Font font, const char *text, float fontSize, float spacing);    // Measure string size for Font
    int GetGlyphIndex(Font font, int codepoint);                                          // Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
    GlyphInfo GetGlyphInfo(Font font, int codepoint);                                     // Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
    Rectangle GetGlyphAtlasRec(Font font, int codepoint);                                 // Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found

    // Text codepoints management functions (unicode characters)
    int *LoadCodepoints(const char *text, int *count);                                    // Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
    void UnloadCodepoints(int *codepoints);                                               // Unload codepoints data from memory
    int GetCodepointCount(const char *text);                                              // Get total number of codepoints in a UTF-8 encoded string
    int GetCodepoint(const char *text, int *bytesProcessed);                              // Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
    const char *CodepointToUTF8(int codepoint, int *byteSize);                            // Encode one codepoint into UTF-8 byte array (array length returned as parameter)
    char *TextCodepointsToUTF8(const int *codepoints, int length);                        // Encode text as codepoints array into UTF-8 text string (WARNING: memory must be freed!)

    // Text strings management functions (no UTF-8 strings, only byte chars)
    // NOTE: Some strings allocate memory internally for returned strings, just be careful!
    int TextCopy(char *dst, const char *src);                                             // Copy one string to another, returns bytes copied
    bool TextIsEqual(const char *text1, const char *text2);                               // Check if two text string are equal
    unsigned int TextLength(const char *text);                                            // Get text length, checks for '\0' ending
    const char *TextFormat(const char *text, ...);                                        // Text formatting with variables (sprintf() style)
    const char *TextSubtext(const char *text, int position, int length);                  // Get a piece of a text string
    char *TextReplace(char *text, const char *replace, const char *by);                   // Replace text string (WARNING: memory must be freed!)
    char *TextInsert(const char *text, const char *insert, int position);                 // Insert text in a position (WARNING: memory must be freed!)
    const char *TextJoin(const char **textList, int count, const char *delimiter);        // Join text strings with delimiter
    const char **TextSplit(const char *text, char delimiter, int *count);                 // Split text into multiple strings
    void TextAppend(char *text, const char *append, int *position);                       // Append text at specific position and move cursor!
    int TextFindIndex(const char *text, const char *find);                                // Find first text occurrence within a string
    const char *TextToUpper(const char *text);                                            // Get upper case version of provided string
    const char *TextToLower(const char *text);                                            // Get lower case version of provided string
    const char *TextToPascal(const char *text);                                           // Get Pascal case notation version of provided string
    int TextToInteger(const char *text);                                                  // Get integer value from text (negative values not supported)
]]

---@alias Font any
---@alias GlyphInfo any
---@alias Image any

--- Get the default Font
---@return Font
function GetFontDefault() end

--- Load font from file into GPU memory (VRAM)
---@param fileName string
---@return Font
function LoadFont(fileName) end

--- Load font from file with extended parameters, use NULL for fontChars and 0 for glyphCount to load the default character set
---@param fileName string
---@param fontSize number
---@param fontChars number[]
---@param glyphCount number
---@return Font
function LoadFontEx(fileName, fontSize, fontChars, glyphCount) end

--- Load font from Image (XNA style)
---@param image Image
---@param key Color
---@param firstChar number
---@return Font
function LoadFontFromImage(image, key, firstChar) end

--- Load font data for further use
---@param fileData string
---@param dataSize number
---@param fontSize number
---@param fontChars number[]
---@param glyphCount number
---@return GlyphInfo[]
function LoadFontData(fileData, dataSize, fontSize, fontChars, glyphCount) end

--- Unload Font from GPU memory (VRAM)
---@param font Font
function UnloadFont(font) end

--- Unload font chars info data (RAM)
---@param chars GlyphInfo[]
function UnloadFontData(chars) end

--- Export font as code file defining an array of bytes for further storage
---@param font Font
---@param fileName string
---@return boolean
function ExportFontAsCode(font, fileName) end

--- Draw current FPS
---@param posX number
---@param posY number
---@param fontSize number
function DrawFPS(posX, posY, fontSize) end

--- Draw text (using default font)
---@param text string
---@param posX number
---@param posY number
---@param fontSize number
---@param color Color
function DrawText(text, posX, posY, fontSize, color) end

--- Draw text using font and additional parameters
---@param text string
---@param position Vector2
---@param fontSize number
---@param spacing number
---@param tint Color
function DrawTextEx(font, text, position, fontSize, spacing, tint) end

--- Draw text using Font and pro parameters (rotation)
---@param text string
---@param position Vector2
---@param origin Vector2
---@param rotation number
---@param fontSize number
---@param spacing number
---@param tint Color
function DrawTextPro(font, text, position, origin, rotation, fontSize, spacing, tint) end

--- Draw one character (codepoint)
---@param font Font
---@param codepoint number
---@param position Vector2
---@param fontSize number
---@param tint Color
function DrawTextCodepoint(font, codepoint, position, fontSize, tint) end

--- Draw multiple characters (codepoints)
---@param font Font
---@param codepoints number[]
---@param count number
---@param position Vector2
---@param fontSize number
---@param spacing number
---@param tint Color
function DrawTextCodepoints(font, codepoints, count, position, fontSize, spacing, tint) end

--- Measure string width for default font
---@param text string
---@param fontSize number
---@return number
function MeasureText(text, fontSize) end

--- Measure string size for Font
---@param font Font
---@param text string
---@param fontSize number
---@param spacing number
---@return Vector2
function MeasureTextEx(font, text, fontSize, spacing) end

--- Get index position for a unicode character on font
---@param font Font
---@param codepoint number
---@return number
function GetGlyphIndex(font, codepoint) end

--- Get glyph font info data for a unicode character
---@param font Font
---@param codepoint number
---@return GlyphInfo
function GetGlyphInfo(font, codepoint) end

--- Get glyph rectangle in font atlas for a given codepoint
---@param font Font
---@param codepoint number
---@return Rectangle
function GetGlyphAtlasRec(font, codepoint) end

-- Text codepoints management functions (unicode characters)

--- Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
---@param text string
---@param count number
---@return number[]
function LoadCodepoints(text, count) end

--- Unload codepoints data from memory
---@param codepoints number[]
function UnloadCodepoints(codepoints) end

--- Get total number of characters (codepoints) in a UTF-8 encoded string
---@param text string
---@return number
function GetCodepointCount(text) end

--- Get next codepoint in a UTF-8 encoded string; 0x3f('?') is returned on failure
---@param text string
---@param bytesProcessed number
---@return number
function GetCodepoint(text, bytesProcessed) end

--- Encode codepoint into utf8 text (char array), returns number of bytes used to store codepoint
---@param codepoint number
---@param byteText number[]
---@return number
function CodepointToUTF8(codepoint, byteText) end

--- Encode text as codepoint array (int array)
---@param text string
---@param count number
---@return number[]
function TextCodepointsToUTF8(text, count) end

--- Copy one string to another, returns bytes copied
---@param dst string
---@param src string
---@return number
function TextCopy(dst, src) end

--- Check if two text string are equal
---@param text1 string
---@param text2 string
---@return boolean
function TextIsEqual(text1, text2) end

--- Get text length, checks for '\0' ending
---@param text string
---@return number
function TextLength(text) end

--- Text formatting with variables (sprintf style)
---@param text string
---@return string
function TextFormat(text, ...) end

--- Get a piece of a text string
---@param text string
---@param position number
---@param length number
---@return string
function TextSubtext(text, position, length) end

--- Replace text string
---@param text string
---@param replace string
---@param by string
---@return string
function TextReplace(text, replace, by) end

--- Insert text in a position
---@param text string
---@param insert string
---@param position number
---@return string
function TextInsert(text, insert, position) end

--- Join text strings with delimiter
---@param textList string[]
---@param count number
---@param delimiter string
---@return string
function TextJoin(textList, count, delimiter) end

--- Split text into multiple strings
---@param text string
---@param delimiter string
---@param count number
---@return string[]
function TextSplit(text, delimiter, count) end

--- Append text at specific position
---@param text string
---@param append string
---@param position number
---@return string
function TextAppend(text, append, position) end

--- Find first text occurrence within a string
---@param text string
---@param find string
---@return number
function TextFindIndex(text, find) end

--- Get upper case version of provided string
---@param text string
---@return string
function TextToUpper(text) end

--- Get lower case version of provided string
---@param text string
---@return string
function TextToLower(text) end

--- Get Pascal case notation version of provided string
---@param text string
---@return string
function TextToPascal(text) end

--- Get integer value from text (negative values not supported)
---@param text string
---@return number
function TextToInteger(text) end
