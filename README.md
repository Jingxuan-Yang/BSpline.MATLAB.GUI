# BSpline.MATLAB.GUI

BSpline MATLAB GUI Program

0. Start the program
Run GUI.m, Zoom, rotate, and move figure handles are on the left top of GUI.

1. Load 2D and 3D data

1) Press “Load 2D Data’ button, and choose a file to load. User could load multiple curve.
2) Press "Load 3D Data" button, and choose a file to load. User could load multiple curve.
3) When user load a new curve, basis function of the new curve could display in basis function axes.
4) When user load a new curve, the degree of the new curve and the number of control points would show below curve axes.

2. Move control points

User could move any control point on the curve axes. Just drag the point.

3. Select a curve

1) User could click on the curve that are decided to interact with.
2) When user click on a curve. The curves’ line width would be thicker and others would be thinner.
3) When user click on a curve. The basis function would change based on the selected curve.

3. Display curve, control points and control polygon

1) Select one curve on the b-spline axes.
2) Check/uncheck curve/control points/control polygon.

4. Change degree
1) Select one curve on the b-spline axes.
2) Change degree by selecting a number on the pop-up menu.
3) When users load or select a curve, the number on the pop-up menu would change to all possible degree.

5. Move knot vector
1) Select a curve
2) Move knot vector on the basis function axes.

6. Change knot vector
1) Select a curve on the b-spline axes.
2) Click on the button of “Modified open uniform knot vector”/ “Floating uniform knot vector”.

7. Create a new curve
1) Enter the curves’ degree first， default value is 2, degree = order - 1.
2) Click on “Create” button, the program would come in ginput process.
3) Click control points on the b-spline axes and press Enter after user finishes adding control points.

8. Insert control point
Insert control point at the beginning and the end
1) Select a curve
2) Click button “Insert a control point at the beginning”/ “Insert a control point at the end”.
3) Add a point on the b-spine axes.

Insert control point in the middle
1) Select a curve
2) Click button “Insert a control point in the middle”.
3) Select two control points by clicking first.
4) Add a new point on the b-spine axes.

9. Delete a control point
1) Select a curve.
2) Click button "Delete a control point".
3) Click near the point that is to be deleted.

10. Clear
Click “Clear” button, the program would re-run and clear all previous data.

11. Exit
Click "Exit" button, the program would exit.
