const String LOGIN = "/rest/V1/integration/customer/token";
const String REGISTER_VEHICLE = "/vehicle/add";
const String SUMBIT_ENTRY = "/vehicle/entrylog/add";
const String SEARCH_BY_REG_NO = "/vehicle/list/";
const String FIND_LAST_ENTRY_BY_DATE = "/vehicle/entrylog/find/";
const String ADD_PUCC_FORM = "/vehicle/pucc/add/";
const String ADD_INSURANCE_FORM = "/vehicle/insurance/add/";
final GET_ENTRIES_BTW_DATES = (vehicleId, dateFrom, dateTo, page) =>
    '/vehicle/entrylog/find/$vehicleId/$dateFrom/$dateTo/$page/';
final GET_EXPENSES_LIST = (vehicleId, dateFrom, dateTo, page) =>
    '/vehicle/expenses/find/$vehicleId/$dateFrom/$dateTo/$page';
const String ADD_EXPENSE = "/expenses/add";
const String VIEW_ENTRY = "/vehicle/entrylog/view";
//new Apis
const String GET_ROUTES_FOR_CLIENT_ID = "/route/client/";
const String GET_ROUTES_FOR_CLIENT_ID_new = "/route/client/";
const String GET_HUB_DATA = "/hub/find/";
const String ADD_CONSIGNMENT_DATA_TO_HUB = "/consignment/add";
const String GET_CONSIGNMENTS_LIST = "/consignment/find/";
const String GET_CLIENTS = "/client/list/";
const String GET_HUBS = "/hub/route/";
final GET_ROUTES_FOR_CLIENT_AND_DATE =
    (clientId, date) => "/route/consignment/client/$clientId/date/$date";
