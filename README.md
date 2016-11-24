# VSM-Tool
Matlab GUI for processing VSM files


INSTRUCTIONS

1. To start, run '>>VSM' from the command window. 
2. To output results when closed, run '>>[ ]=VSM' from the command wondow where [ ] includes the options listed below
3. select a VHD file generated by the VSM
4. it will display the raw in and out of plane data
5. select with the pop-up menu if you want to process the in or out of plane data
6. it generates estimates for linear subtraction, drift and
7. fine tune the correction
8. close window to output results


return options are:

[field    Mcorr   Ms    drift   gradient    offset    Mraw    time] = VSM

drift is in emu/s
gradient is in emu/Oe

The corrected Magnetisation (Mcor) is generated from raw Magnetisation (Mraw) by:

Mcor=Mraw-gradient*field-drift*time-offset

