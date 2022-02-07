This directory contains MATLAB code that can be used to replicate calculations in Rood and others, 'Validation of earthquake ground-motion models in southern California using precariously balanced rocks'.

This software requires MATLAB (www.mathworks.com) and the MATLAB Optimization Toolbox. 

All the code in this directory was written by Greg Balco and Anna Rood.

Contact: Greg Balco, balcs@bgc.org

The calculation method is described in the following reference:

Balco, G., Purvance, M.D. and Rood, D.H., 2011. Exposure dating of precariously balanced rocks. Quaternary Geochronology, 6(3-4), pp.295-303.

Some m-files in this directory were originally distributed as part of the online exposure age calculators described in this reference:

Balco, G., Stone, J.O., Lifton, N.A. and Dunai, T.J., 2008. A complete  and easily accessible means of calculating surface exposure ages or erosion rates from 10Be and 26Al measurements. Quaternary Geochronology,  3(3), pp.174-195.
 
To reproduce optimization calculations for a particular PBR, do the following:

1. Execute the m-file called 'make_PBR_consts.m' to generate a .mat file of constants needed for the calculations. Note: although you only need to do this step once, if you change any of the constants values in make_PBR_consts.m, you must execute it again to update the .mat-file. 

2. Execute the m-file called 'NameOfPBR_data_YYYYMMDD.m'. This generates a .mat-file with a similar filename containing site, sample, and production rate information needed by the optimizer. Note: if you change any of the data in one of these .m-files, you must execute it again to update the .mat-file.  

3. Execute the script called 'PBR_model_window.m'. This will bring up a window entitled 'PBR exposure model wrapper'. Click the 'choose file' button in that window. Select the .mat-file you just created. Adjust the selections in the various windows and proceed. 

Standard selections used for the optimizations are as follows:

Forward model scheme: "4-parameter: distinct E0,sp, E0,mu"
Run optimizer: "Monte Carlo uncertainty estimate, local"
Iterations: 400

LICENSE

As some of this software was originally distributed under the GNU General Public License, Version 2 (GPL2), all files in this directory, which make use of the older files, inherit the same license. The GNU GPL2 permits commercial use. 

DISCLAIMER

The software in this directory is expressly provided “AS IS.” The authors of the software and/or the accompanying scientific paper (henceforth, ’the authors’) make no warranty of any kind, express, implied, in fact or arising by operation of law, including, without limitation, the implied warranty of merchantability, fitness for a particular purpose, non-infringement and data accuracy. The authors neither represent nor warrant that the software will be error-free, or that any defects will be corrected. The authors do not warrant or make any representations regarding the use of the software or the results thereof, including but not limited to the correctness, accuracy, reliability, or usefulness of the software. 

The authors do not warrant or make any representations regarding whether or not the software is suitable for use in any situation where a failure could cause risk of injury or damage to property. You are solely responsible for determining the appropriateness of using and distributing the software and you assume all risks associated with its use, including but not limited to the risks and costs of program errors, compliance with applicable laws, damage to or loss of data, programs or equipment, and the unavailability or interruption of operation. In no event shall the authors be liable to any party for direct, indirect, special, incidental, or consequential damages, including lost profits, arising out of the use of this software, even if the authors have been advised of the possibility of such damage. 

INDEMNITY BY USE OF SOFTWARE OR CONTRACTING FOR PROFESSIONAL SERVICES USING THE SOFTWARE

For purpose of this provision “Providers” of this software are the authors, the employer of each author, and the author’s publisher.  “Users” are both each professional entity which incorporates the software from this source as part of its to provision of professional services as well as each entity which contracts for professional services that incorporate the software.

Users each independently agree to indemnify, protect, defend (by counsel reasonably acceptable to the providers) and hold harmless providers’ affiliated entities, and each of the providers respective members, managers, partners, directors, officers, employees, shareholders, successors, assigns, from and against any and all claims, judgments, causes of action, damages, penalties, fines, taxes, costs, liabilities, losses, and expenses (including attorney fees, expenses, and court costs) arising at any time during or after the contract for professional services. Users’ obligations under the foregoing indemnity shall survive the termination or expiration of the contract for professional services. 
