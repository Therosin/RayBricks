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
---@meta raylib-lua-sol shapes


--[[
    // Set texture and rectangle to be used on shapes drawing
    // NOTE: It can be useful when using basic shapes and one single font,
    // defining a font char white rectangle would allow drawing everything in a single draw call
    void SetShapesTexture(Texture2D texture, Rectangle source);       // Set texture and rectangle to be used on shapes drawing

    // Basic shapes drawing functions
    void DrawPixel(int posX, int posY, Color color);                                                   // Draw a pixel
    void DrawPixelV(Vector2 position, Color color);                                                    // Draw a pixel (Vector version)
    void DrawLine(int startPosX, int startPosY, int endPosX, int endPosY, Color color);                // Draw a line
    void DrawLineV(Vector2 startPos, Vector2 endPos, Color color);                                     // Draw a line (Vector version)
    void DrawLineEx(Vector2 startPos, Vector2 endPos, float thick, Color color);                       // Draw a line defining thickness
    void DrawLineBezier(Vector2 startPos, Vector2 endPos, float thick, Color color);                   // Draw a line using cubic-bezier curves in-out
    void DrawLineBezierQuad(Vector2 startPos, Vector2 endPos, Vector2 controlPos, float thick, Color color); // Draw line using quadratic bezier curves with a control point
    void DrawLineBezierCubic(Vector2 startPos, Vector2 endPos, Vector2 startControlPos, Vector2 endControlPos, float thick, Color color); // Draw line using cubic bezier curves with 2 control points
    void DrawLineStrip(Vector2 *points, int pointCount, Color color);                                  // Draw lines sequence
    void DrawCircle(int centerX, int centerY, float radius, Color color);                              // Draw a color-filled circle
    void DrawCircleSector(Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color);      // Draw a piece of a circle
    void DrawCircleSectorLines(Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color); // Draw circle sector outline
    void DrawCircleGradient(int centerX, int centerY, float radius, Color color1, Color color2);       // Draw a gradient-filled circle
    void DrawCircleV(Vector2 center, float radius, Color color);                                       // Draw a color-filled circle (Vector version)
    void DrawCircleLines(int centerX, int centerY, float radius, Color color);                         // Draw circle outline
    void DrawEllipse(int centerX, int centerY, float radiusH, float radiusV, Color color);             // Draw ellipse
    void DrawEllipseLines(int centerX, int centerY, float radiusH, float radiusV, Color color);        // Draw ellipse outline
    void DrawRing(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color); // Draw ring
    void DrawRingLines(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color);    // Draw ring outline
    void DrawRectangle(int posX, int posY, int width, int height, Color color);                        // Draw a color-filled rectangle
    void DrawRectangleV(Vector2 position, Vector2 size, Color color);                                  // Draw a color-filled rectangle (Vector version)
    void DrawRectangleRec(Rectangle rec, Color color);                                                 // Draw a color-filled rectangle
    void DrawRectanglePro(Rectangle rec, Vector2 origin, float rotation, Color color);                 // Draw a color-filled rectangle with pro parameters
    void DrawRectangleGradientV(int posX, int posY, int width, int height, Color color1, Color color2);// Draw a vertical-gradient-filled rectangle
    void DrawRectangleGradientH(int posX, int posY, int width, int height, Color color1, Color color2);// Draw a horizontal-gradient-filled rectangle
    void DrawRectangleGradientEx(Rectangle rec, Color col1, Color col2, Color col3, Color col4);       // Draw a gradient-filled rectangle with custom vertex colors
    void DrawRectangleLines(int posX, int posY, int width, int height, Color color);                   // Draw rectangle outline
    void DrawRectangleLinesEx(Rectangle rec, float lineThick, Color color);                            // Draw rectangle outline with extended parameters
    void DrawRectangleRounded(Rectangle rec, float roundness, int segments, Color color);              // Draw rectangle with rounded edges
    void DrawRectangleRoundedLines(Rectangle rec, float roundness, int segments, float lineThick, Color color); // Draw rectangle with rounded edges outline
    void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color);                                // Draw a color-filled triangle (vertex in counter-clockwise order!)
    void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color);                           // Draw triangle outline (vertex in counter-clockwise order!)
    void DrawTriangleFan(Vector2 *points, int pointCount, Color color);                                // Draw a triangle fan defined by points (first vertex is the center)
    void DrawTriangleStrip(Vector2 *points, int pointCount, Color color);                              // Draw a triangle strip defined by points
    void DrawPoly(Vector2 center, int sides, float radius, float rotation, Color color);               // Draw a regular polygon (Vector version)
    void DrawPolyLines(Vector2 center, int sides, float radius, float rotation, Color color);          // Draw a polygon outline of n sides
    void DrawPolyLinesEx(Vector2 center, int sides, float radius, float rotation, float lineThick, Color color); // Draw a polygon outline of n sides with extended parameters

    // Basic shapes collision detection functions
    bool CheckCollisionRecs(Rectangle rec1, Rectangle rec2);                                           // Check collision between two rectangles
    bool CheckCollisionCircles(Vector2 center1, float radius1, Vector2 center2, float radius2);        // Check collision between two circles
    bool CheckCollisionCircleRec(Vector2 center, float radius, Rectangle rec);                         // Check collision between circle and rectangle
    bool CheckCollisionPointRec(Vector2 point, Rectangle rec);                                         // Check if point is inside rectangle
    bool CheckCollisionPointCircle(Vector2 point, Vector2 center, float radius);                       // Check if point is inside circle
    bool CheckCollisionPointTriangle(Vector2 point, Vector2 p1, Vector2 p2, Vector2 p3);               // Check if point is inside a triangle
    bool CheckCollisionLines(Vector2 startPos1, Vector2 endPos1, Vector2 startPos2, Vector2 endPos2, Vector2 *collisionPoint); // Check the collision between two lines defined by two points each, returns collision point by reference
    bool CheckCollisionPointLine(Vector2 point, Vector2 p1, Vector2 p2, int threshold);                // Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
    Rectangle GetCollisionRec(Rectangle rec1, Rectangle rec2);                                         // Get collision rectangle for two rectangles collision

]]

--- Set texture and rectangle to be used on shapes drawing
---@param texture Texture
---@param source Rectangle
function SetShapesTexture(texture, source) end

--- Draw a pixel
---@param posX number
---@param posY number
---@param color Color
function DrawPixel(posX, posY, color) end

--- Draw a pixel (Vector version)
---@param position Vector2
---@param color Color
function DrawPixelV(position, color) end

--- Draw a line
---@param startPosX number
---@param startPosY number
---@param endPosX number
---@param endPosY number
---@param color Color
function DrawLine(startPosX, startPosY, endPosX, endPosY, color) end

--- Draw a line (Vector version)
---@param startPos Vector2
---@param endPos Vector2
---@param color Color
function DrawLineV(startPos, endPos, color) end

--- Draw a line defining thickness
---@param startPosX number
---@param startPosY number
---@param endPosX number
---@param endPosY number
---@param thick number
---@param color Color
function DrawLineEx(startPosX, startPosY, endPosX, endPosY, thick, color) end

--- Draw a line defining thickness (Vector version)
---@param startPos Vector2
---@param endPos Vector2
---@param thick number
---@param color Color
function DrawLineVEx(startPos, endPos, thick, color) end

--- Draw a line using cubic-bezier curves in-out
---@param startPos Vector2
---@param endPos Vector2
---@param thick number
---@param color Color
function DrawLineBezier(startPos, endPos, thick, color) end

--- Draw a line using cubic-bezier curves in-out, variant with extended parameters
---@param startPos Vector2
---@param endPos Vector2
---@param thick number
---@param color Color
function DrawLineBezierQuad(startPos, endPos, thick, color) end

--- Draw a color-filled circle
---@param centerX number
---@param centerY number
---@param radius number
---@param color Color
function DrawCircle(centerX, centerY, radius, color) end

--- Draw a piece of a circle
---@param center Vector2
---@param radius number
---@param startAngle number
---@param endAngle number
---@param segments number
---@param color Color
function DrawCircleSector(center, radius, startAngle, endAngle, segments, color) end

--- Draw circle sector outline
---@param center Vector2
---@param radius number
---@param startAngle number
---@param endAngle number
---@param segments number
---@param color Color
function DrawCircleSectorLines(center, radius, startAngle, endAngle, segments, color) end

--- Draw a gradient-filled circle
---@param centerX number
---@param centerY number
---@param radius number
---@param color1 Color
---@param color2 Color
function DrawCircleGradient(centerX, centerY, radius, color1, color2) end

--- Draw a color-filled circle (Vector version)
---@param center Vector2
---@param radius number
---@param color Color
function DrawCircleV(center, radius, color) end

--- Draw circle outline
---@param centerX number
---@param centerY number
---@param radius number
---@param color Color
function DrawCircleLines(centerX, centerY, radius, color) end

--- Draw circle outline (Vector version)
---@param center Vector2
---@param radius number
---@param color Color
function DrawCircleLinesV(center, radius, color) end

--- Draw ellipse
---@param centerX number
---@param centerY number
---@param radiusH number
---@param radiusV number
---@param color Color
function DrawEllipse(centerX, centerY, radiusH, radiusV, color) end

--- Draw ellipse outline
---@param centerX number
---@param centerY number
---@param radiusH number
---@param radiusV number
---@param color Color
function DrawEllipseLines(centerX, centerY, radiusH, radiusV, color) end

--- Draw a color-filled rectangle
---@param posX number
---@param posY number
---@param width number
---@param height number
---@param color Color
function DrawRectangle(posX, posY, width, height, color) end

--- Draw a color-filled rectangle (Vector version)
---@param position Vector2
---@param size Vector2
---@param color Color
function DrawRectangleV(position, size, color) end

--- Draw a color-filled rectangle
---@param rec Rectangle
---@param color Color
function DrawRectangleRec(rec, color) end

--- Draw a color-filled rectangle with pro parameters
---@param rec Rectangle
---@param roundness number
---@param segments number
---@param color Color
function DrawRectangleRounded(rec, roundness, segments, color) end

--- Draw a color-filled rectangle with pro parameters
---@param rec Rectangle
---@param roundness number
---@param segments number
---@param lineThick number
---@param color Color
function DrawRectangleRoundedLines(rec, roundness, segments, lineThick, color) end

--- Draw a vertical-gradient-filled rectangle
---@param posX number
---@param posY number
---@param width number
---@param height number
---@param color1 Color
---@param color2 Color
function DrawRectangleGradientV(posX, posY, width, height, color1, color2) end

--- Draw a horizontal-gradient-filled rectangle
---@param posX number
---@param posY number
---@param width number
---@param height number
---@param color1 Color
---@param color2 Color
function DrawRectangleGradientH(posX, posY, width, height, color1, color2) end

--- Draw a gradient-filled rectangle with custom vertex colors
---@param rec Rectangle
---@param col1 Color
---@param col2 Color
---@param col3 Color
---@param col4 Color
function DrawRectangleGradientEx(rec, col1, col2, col3, col4) end

--- Draw rectangle outline
---@param posX number
---@param posY number
---@param width number
---@param height number
---@param color Color
function DrawRectangleLines(posX, posY, width, height, color) end

--- Draw rectangle outline with extended parameters
---@param rec Rectangle
---@param lineThick number
---@param color Color
function DrawRectangleLinesEx(rec, lineThick, color) end

--- Draw rectangle outline (Vector version)
---@param position Vector2
---@param size Vector2
---@param color Color
function DrawRectangleLinesV(position, size, color) end

--- Draw a color-filled triangle
---@param v1 Vector2
---@param v2 Vector2
---@param v3 Vector2
---@param color Color
function DrawTriangle(v1, v2, v3, color) end

--- Draw triangle outline
---@param v1 Vector2
---@param v2 Vector2
---@param v3 Vector2
---@param color Color
function DrawTriangleLines(v1, v2, v3, color) end

--- Draw a regular polygon (Vector version)
---@param center Vector2
---@param sides number
---@param radius number
---@param rotation number
---@param color Color
function DrawPoly(center, sides, radius, rotation, color) end

--- Draw a polygon outline of n sides
---@param center Vector2
---@param sides number
---@param radius number
---@param rotation number
---@param color Color
function DrawPolyLines(center, sides, radius, rotation, color) end

--- Draw a polygon outline of n sides with extended parameters
---@param center Vector2
---@param sides number
---@param radius number
---@param rotation number
---@param lineThick number
---@param color Color
function DrawPolyLinesEx(center, sides, radius, rotation, lineThick, color) end


--- Check collision between two rectangles
---@param rec1 any
---@param rec2 any
---@return boolean
function CheckCollisionRecs(rec1, rec2) end


--- Check collision between two circles
---@param center1 any
---@param radius1 number
---@param center2 any
---@param radius2 number
---@return boolean
function CheckCollisionCircles(center1, radius1, center2, radius2) end


--- Check collision between circle and rectangle
---@param center any
---@param radius number
---@param rec any
---@return boolean
function CheckCollisionCircleRec(center, radius, rec) end


--- Check if point is inside rectangle
---@param point any
---@param rec any
---@return boolean
function CheckCollisionPointRec(point, rec) end


--- Check if point is inside circle
---@param point any
---@param center any
---@param radius number
---@return boolean
function CheckCollisionPointCircle(point, center, radius) end


--- Check if point is inside a triangle
---@param point any
---@param p1 any
---@param p2 any
---@param p3 any
---@return boolean
function CheckCollisionPointTriangle(point, p1, p2, p3) end


--- Check the collision between two lines defined by two points each, returns collision point by reference
---@param startPos1 any
---@param endPos1 any
---@param startPos2 any
---@param endPos2 any
---@param collisionPoint any
---@return boolean
function CheckCollisionLines(startPos1, endPos1, startPos2, endPos2, collisionPoint) end


--- Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
---@param point any
---@param p1 any
---@param p2 any
---@param threshold number
---@return boolean
function CheckCollisionPointLine(point, p1, p2, threshold) end


--- Get collision rectangle for two rectangles collision
---@param rec1 any
---@param rec2 any
---@return any
function GetCollisionRec(rec1, rec2) end
