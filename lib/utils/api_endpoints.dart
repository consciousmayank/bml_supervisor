import 'package:bml_supervisor/app_level/shared_prefs.dart';

const String REGISTER_VEHICLE = "/vehicle/add";
const String SUMBIT_ENTRY = "/dailyKilometer/add";
const String SEARCH_BY_REG_NO = "/vehicle/list/";

final FIND_LAST_ENTRY_BY_DATE =
    (vehicleId) => "/dailyKilometer/recent/entry/vehicle/$vehicleId";

final GET_DAILY_DRIVEN_KMS_BAR_CHART =
    (clientId, period) => "/dailyKilometer/client/$clientId/period/$period";

final GET_ROUTES_DRIVEN_KM =
    (clientId, period) => "/route/drivenKm/client/$clientId/period/$period";

final GET_CONSIGNMENT_LIST_FOR_A_CLIENT_AND_DATE =
    (clientId, date) => "/consignment/list/client/$clientId/date/$date";

final GET_CONSIGNMENT_LIST_BY_ID =
    (consignmentId) => "/consignment/$consignmentId";

final GET_ROUTES_DRIVEN_KM_PERCENTAGE = //06 Get Client Aggregate Driven Km (Donut Chart)
    (clientId, period) =>
        "/route/drivenKm/aggregate/client/$clientId/period/$period";

const String ADD_PUCC_FORM = "/vehicle/pucc/add/";
const String ADD_INSURANCE_FORM = "/vehicle/insurance/add/";
final GET_ENTRIES_BTW_DATES = (vehicleId, dateFrom, dateTo, page) =>
    '/vehicle/entrylog/find/$vehicleId/$dateFrom/$dateTo/$page/';
final GET_EXPENSES_LIST = '/expense/view';
const String ADD_EXPENSE = "/expense/add";
const String VIEW_ENTRY = "/vehicle/entrylog/view";
//new Apis
const String GET_ROUTES_FOR_CLIENT_ID = "/route/list/client/";
const String GET_ROUTES_FOR_CLIENT_ID_new = "/route/list/client/";
const String GET_HUB_DATA = "/hub/find/";
const String ADD_CONSIGNMENT_DATA_TO_HUB = "/consignment/add";
const String GET_CONSIGNMENTS_LIST = "/consignment/find/";

final GET_HUBS = (routeId) => "/route/$routeId/hub/list";
final GET_ROUTES_FOR_CLIENT_AND_DATE =
    (clientId, date) => "/consignment/route/list/client/$clientId/date/$date";
final GET_CONSIGNMENT_FOR_CLIENT_AND_DATE = (clientId, routeId, date) =>
    "/consignment/client/$clientId/route/$routeId/date/$date";
final GET_PAYMENT_HISTORY =
    (clientId, pageNumber) => "/payment/list/client/$clientId/page/$pageNumber";

final GET_EXPENSES_FOR_CLIENT_AND_PERIOD =
    (clientId, period) => "/expense/list/client/$clientId/period/$period";

final GET_DASHBOARD_STATS = (PreferencesSavedUser user) => user.role == 'CLIENT'
    ? '/client/${user.userName}/dashboard/statistics'
    : user.role == 'ADMIN'
        ? '/admin/${user.userName}/dashboard/statistics'
        : '/manager/${user.userName}/dashboard/statistics';

/////////////////////////Post Security/////////////////////////
final LOGIN = '/user/auth';

final GET_DASHBOARD_TILES = //06 Get Client Aggregate Driven Km (Donut Chart)
    (clientId) => "/manager/dashboard/statistics/client/goldenharvest";

const String GET_CLIENTS = "/manager/client/list";
const String GET_DAILY_ENTRIES = '/dailyKilometer/view';
final GET_DAILY_KM_INFO = (date) => "//dailyKilometer/info/$date";

///////////////////////////////////////////////////////////////
