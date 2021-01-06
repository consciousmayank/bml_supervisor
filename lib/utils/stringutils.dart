const String launcher_page_title = "Welcome";
const String supervisor_page_title = "SuperVisor";
const String registration_page_title = "Vehicle Registration";
const String no_network_message = "No Connected to Internet";
const String launcher_page_sub_title = "Continue As :";
const String launcher_page_superviser_button_title = "SuperVisor";
const String supervisor_page_superviser_vr_title = "Vehicle";
const String supervisor_page_superviser_pucc_title = "PUCC";
const String supervisor_page_superviser_insurance_title = "Insurance";
const String supervisor_page_superviser_dr_title = "Daily Report";

//Regex patterns
const String textPasswordPattern =
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
const String chasisNumberHint = "Enter Chasis Number";
const String invalidChasisNumber = "Invalid Chasis number";

const String registrationNumberHint = "Enter Registration Number";
const String invalidRegistrationNumber = "Invalid Registration number";

const String engineNumberHint = "Enter Engine Number";
const String invalidEngineNumber = "Invalid Engine number";

const String vehicleMakeHint = "Enter Vehicle Make";
const String invalidVehicleMake = "Invalid Vehicle Made";

const String vehicleModelHint = "Enter Vehicle Model";
const String invalidVehicleModel = "Enter Vehicle Model";

const String rtoHint = "Enter RTO";
const String invalidRto = "Invalid RTO";

const String vehicleColorHint = "Enter Vehicle Color";
const String invalidVehicleColor = "Incalid Vehicle Color";

const String vehicleInitialReadingHint = "Enter Start Reading : ";
const String fuelReadingHint = "Enter Fuel (in Litres)";
const String fuelRateHint = "Enter Fuel Rate";
const String fuelAmountHint = "Total Amount Paid";
const String fuelMeterReadingHint = "Meter Reading ";
const String invalidVehicleInitialReading = "Invalid Reading";

const String vehicleLoadCapacityHint = "Enter Load Capacity (in Kgs)";
const String invalidVehicleLoadCapacity = "Invalid Load Capacity";

const String ownerNameHint = "Enter Current Owner Name";
const String lastOwnerNameHint = "Enter Last Owner Name";

const String invalidDate = "Invalid Date";
const String textRequired = "required";
const String invalidName = "Invalid Name";
const String registrationUptoHint = "Registration Expiry Date";
const String registrationDateHint = "Registration Date";
const String ownerLevelHint = "Select Owner Level";
const String vehicleClassHint = "Select Vehicle Class";
const String vehicleFuelTypeHint = "Select Fuel Type";
const String vehicleEmissionTypeHint = "Select Emmision Type";
const String vehicleSeatingCapacityHint = "Select Vehicle Seating Capacity";
const String drRegNoHint = "Registration No";
const String searchPageTitleHint = "Enter Registration Number";
const String fuelMeterReadingError =
    "Fuel meter reading has to be between Start Reading and End Reading.";
const String vehicleEntryEndReadingError =
    "End Reading cannot be less then, or equal to Start Reading";

const String vehicleEntryStartReadingError =
    "Start Reading cannot be less then, yesterday's End Reading";

const String logoutTimeError =
    "Logout time cannot be less then, or equal to Login time";

const List<String> ownerLevelList = ["1", "2", "3", "4", "5"];
const List<String> vehicleClassList = ["Goods Carrier"];
const List<String> vehicleSeatingList = ["2"];
const List<String> vehicleEmmisionTypeList = [
  "BS I",
  "BS II",
  "BS III",
  "BS IV",
  "BS VI"
];
const List<String> vehicleFuelTypeList = [
  "Diesel",
  "Petrol",
  "Electric",
  "Solar"
];

const List<String> superVisorPageTabs = [
  'Registration Info',
  'PUCC Info',
  'Insurance Info'
];

const List<String> dailyReportsPageTabs = [
  'Daily Entry',
  'Daily Expenses',
];

const List<String> expenseTypes = [
  'Breakdown',
  'Challan',
  'Parking',
  'Spare Part',
  'Toll',
  'Union',
  'Others'
];

const List<String> selectDurationList = [
  "THIS MONTH",
  "LAST MONTH",
];
const List<String> selectClientList = [
  'BOOK MY LOADING',
  "GOLDEN HARVEST",
];

const String registrationText = "Registration";
const String addText = "Add";
const String viewText = "View";
const String searchText = "Search";
const String entryLogsText = "Entry Logs";
const String expensesText = "Expenses";
const String entryStartReadingHint = "Enter Start Reading(Km)";
const String entryEndReadingHint = "Enter End Reading(Km)";
const String rupeeSymbol = "\u{20B9} ";

const String certificateNumberHint = "Policy Number";
const String certificateNumberError = "Invalid Policy Number";
const String insuredPersonHint = "Insured Person";
const String agentCodeHint = "Agent Code";
const String agentContactNoHint = "Agent Contact Number";
const String agentNameHint = "Agent Name";
const String insuredPersonContactNoHint = "Contact Number";
const String premiumAmountHint = "Insurance Premium";
const String insuredAmountHint = "Insured Amount";
const String insuranceTypeHint = "Insurance Type";
const String issueDateHint = "Issue Date";
const String expiryDateHint = "Expiry Date";
const String appTitle = "BookMyLoading";
const String vehicleExpensesTitle = "Vehicle Expenses";
const List<String> insuranceTypeList = ["First", "Third"];
const List<String> searchApiParams = [
  'Registration Number',
  'Owner',
  'Chassis',
  'Engine Number',
];
const List<String> tempRoutes = [
  'R1',
  'R2',
  'R3',
  'R4',
  'R5',
];
