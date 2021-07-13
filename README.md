# mini-eLiXiVy
## Repository for the mini-eLiXiVy, a 65% mechanical keyboard PCB, suitable for ISO and ANSI layouts, USB Type C and a (tactile) rotary encoder.
 This PCB is compatible with KBDFans' 65% low profile case/plate and Cherry MX(-like) keyswitches.
![mini-eLiXiVy-PCB-Render](/Documents/Images/PCBPicture.png)
 _Render of the front and back of the PCB respectively_

 The PCB and schematic are licensed under CERN-OHL-S v2, full license details can be found here: https://github.com/minibois/eLiXiVy/blob/master/Documents/LICENSE.txt

### The compatible layouts for this PCB are as follows:
![mini-eLiXiVy-Layouts-Supported](/Documents/Layouts/layouts.png)
 _The mini-eLiXiVy supports between 66 and 69 switches, depending on the layout chosen_
 In the top right of the keyboard you can either use an MX-like keyswitch or a rotary encoder with switch (see the BOM for a verified compatible option).
 
 Bill of materials: https://octopart.com/bom-tool/allQRgda (see ../Documents for a .txt and .xlsx version of the BOM).
 While the the bill of materials mentions tested compatible components, substitutes may be available, should these components become difficult to obtain. Should you choose alternatives, you do so at your own risk. I can only vouch for the compability of the listed components.

 Used libraries (symbols/footprints have been edited for the use in this project):
 * That-Canadian's KiCad_labs (for the D-SOD123_axial-dual): https://github.com/That-Canadian/KiCad_Libs
 * Type-C.Pretty: https://github.com/ai03-2725/Type-C.pretty
 * MX_Alps_Hybrid: https://github.com/ai03-2725/MX_Alps_Hybrid
 * random-keyboard-parts (for a reset switch): https://github.com/ai03-2725/random-keyboard-parts.pretty

### This PCB file and schematic is provided - as per CERN-OHL-S v2 section 6 - _without any warranty_ (implied or otherwise).