# Generating a Mesh

## Mesh formats

Meshes can be generated for NekRS by a variety of tools, but must be converted to a specific binary `.re2` format used by NekRS. Common formats that can be converted include the GMSH `.msh` format (noting that this is not the same as the ANSYS Fluent `.msh` format) using `gmsh2nek`, and the commonly used EXODUS II `.exo` format using `exo2nek`.

For this case, a `.exo` mesh is produced using Coreform Cubit, however meshes can also be generated using other methods and converted to `.exo` format (such as generating a `.msh` mesh in Fluent and converting this to `.exo` via Cubit). This mesh is included in this directory, as well as the `.jou` script used to generate the mesh in Cubit.

## Mesh requirements

NekRS itself only uses hexahedral elements, but at the conversion stage some other element types can be decomposed to generate a pure hex mesh. 3D meshes that contain the following element types can be used in NekRS:

- TET4 + WEDGE6 + HEX8 (1st order)
- TET10 + WEDGE15 (2nd order)
- HEX20 (2nd order)

For the first and second cases, each TET will be split into 4 HEX elements, each WEDGE will be split into 3 HEX elements, and for the first case each HEX element will be split into 8 HEX elements (even if the mesh only contains HEX8 elements). For the HEX20 case, the elements are not split.

Second order element types (such as HEX20) contain information about second order the curvature of elements. If a mesh composed of second order elements is provided to NekRS, the distribution of GLL quadrature points within the element follows this curvature; as such, second order meshes are valuable for ensuring the high order elements conform to curved surfaces, which can otherwise be significantly faceted due to the relatively large size of high order elements compared to an equivalent mesh for a low order solver. Note that the order of the elements in the original mesh (first or second order) is unrelated to the polynomial order used in the NekRS solve.

In general, HEX20 or TET10+WEDGE15 meshes are recommended.

## Converting an EXODUS mesh

The mesh can be converted from `.exo` format to `.re2` by using `exo2nek`. This tool is not provided in the core NekRS code, but can be obtained from the Nek5000 repository:

```
git clone https://github.com/Nek5000/Nek5000.git
cd Nek5000/tools
./maketools all
```

The `build_exo2nek.sh` script provided in this directory performs these steps, as well as writing a `~/.nektools_profile` file which adds the compiled Nek5000 tool binaries to the `$PATH`.

Once the tools have been compiled and the binaries are in the `$PATH`, run `exo2nek` from this directory. The tool will then prompt the user to enter some details about the mesh file(s) to be converted, and print information to the user. The key entries required to successfully convert this mesh are shown below.

```
$ exo2nek
 please input number of fluid exo files:
1
 please input exo file:
pipe
```
Note, this is the name of the file without the `.exo` or `.e` extension.
```
 please input number of solid exo files for CHT problem (input 0 for no solid mesh):
0
```
Solid files can also be loaded during exo2nek, to be used for conjugate heat transfer problems performed entirely within NekRS (this workshop will cover the alternative method of using Cardinal for conjugate heat transfer).
```
 For Fluid domain
 Enter number of periodic boundary surface pairs:
0
```
In this case, periodic boundary conditions will not be used (instead setting a fixed inlet velocity profile and a fixed pressure outlet), but for NekRS cases that will use periodic BCs the pairs of periodic boundary surfaces must be specified here.
```
 please give re2 file name:
pipe
```
Finally, the mesh is named `pipe.re2`, noting that here the desired filename must be given without the `.re2` extension.