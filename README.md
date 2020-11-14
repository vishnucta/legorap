# legorap

## Description

This repository contains code for Asset Management system using  ABAP RESTful Application Programming Model (RAP) in SAP Cloud Platform, ABAP environment.

Hello Team,

Welcome the Usecase start up guide.

Steps to Run :

1) Configure ABAP Cloud Platform in your personal Eclipse IDE 
    https://developers.sap.com/tutorials/abap-environment-trial-onboarding.html
    
2) Clone your project into your Custom Package

3) Do activation as per below order to avoid error. Due to some reason even though Mass activation list all aritifacts , it end up not activating all.
Select all aritifacts in below listed folder and activate folder by folder

    - Domains
    - Data Element
    - Database Tables
    - Data Definitions
    - Metadata Extensions
    - Classes
    - Behavior Definitions
    - Service Definitions
    - Service Bindings


5) Just to avoid any unexpected error, just make sure all artifacts are activated in its respective folders.

6) Publish the service Binding and preview the App from the Root BO/View

7) Run ABAP class ZCL_GENERATE_ASSET_DATA(Make sure classes are active too) to populate table zmarket_t(Market Value Help) and ZPRODSTAT_T (Status Value Help)



Ready to run :+1:

For any queries, reachout to me at vishnucta@gmail.com

