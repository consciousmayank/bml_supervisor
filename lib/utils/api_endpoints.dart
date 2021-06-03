import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/login_response.dart';

const String REGISTER_VEHICLE = "/vehicle/add";
const String SUMBIT_ENTRY = "/dailyKilometer/add";
const String SEARCH_BY_REG_NO = "/vehicle/list/";

final FIND_LAST_ENTRY_BY_DATE =
    (vehicleId) => "/dailyKilometer/recent/entry/vehicle/$vehicleId";

final GET_LAST_SEVEN_ENTRIES =
    (clientId) => "/manager/recent/drivenKm/client/$clientId";

final GET_DAILY_DRIVEN_KMS_BAR_CHART =
    (clientId, period) => "/dailyKilometer/client/$clientId";

final GET_ROUTES_DRIVEN_KM = (clientId) => "/route/drivenKm/client/$clientId";

final GET_CONSIGNMENT_LIST_FOR_A_CLIENT_AND_DATE =
    (clientId, date) => "/consignment/list/client/$clientId/date/$date";

final GET_PENDING_CONSIGNMENTS_LIST_FOR_A_CLIENT = (clientId, pageIndex) =>
    "/consignment/list/assess/false/client/$clientId/page/$pageIndex";

final GET_CONSIGNMENT_LIST_PAGE_WISE = (clientId, pageIndex) =>
    "/consignment/list/client/$clientId/page/$pageIndex";

final GET_RECENT_CONSIGNMENTS_FOR_CREATE_CONSIGNMENT =
    (clientId) => "/consignment/list/recent/client/$clientId";

final GET_CONSIGNMENT_LIST_BY_ID =
    (consignmentId) => "/consignment/$consignmentId";
final GET_COMPLETED_TRIPS_BY_ID = (consignmentId, clientId) =>
    "/consignment/$consignmentId/client/$clientId/tracking/status/completed";

final GET_ROUTES_DRIVEN_KM_PERCENTAGE = //06 Get Client Aggregate Driven Km (Donut Chart)
    (clientId) => "/route/drivenKm/aggregate/client/$clientId";

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
const String ADD_VEHICLE = "/vehicle/add";
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

/////////////////////////Post Security/////////////////////////
final LOGIN = '/manager/auth';

final GET_DASHBOARD_TILES = //06 Get Client Aggregate Driven Km (Donut Chart)
    (clientId) => "/manager/dashboard/statistics/client/$clientId";

final GET_CLIENTS = (pageNumber) => "/manager/client/list/page/$pageNumber";
const String GET_USER = "/manager/profile";
const String UPDATE_USER_MOBILE = "/manager/update/mobile";
const String UPDATE_USER_EMAIL = "/manager/update/email";
const String CHANGE_PASSWORD = "/manager/update/password";
const String GET_APP_VERSION = "/info/get/version";
const String GET_CITIES = "/location/city/list";
const String ADD_DRIVER = "/manager/driver/add";
const String ADD_ROUTE = "/route/add";
const String ADD_HUB = "/hub/add";
const String GET_DAILY_ENTRIES = '/dailyKilometer/view';
final GET_DAILY_KM_INFO = (date) => "/dailyKilometer/info/$date";
final GET_CITY_LOCATION = (cityId) => "/location/city/$cityId";
final GET_ROUTE_DETAILS = (routeId) => "/route/$routeId";
final GET_HUB_DETAILS = (hubId) => "/hub/$hubId";
final GET_EXPENSE_PIE_CHART =
    (clientId) => "/expense/aggregate/client/$clientId";
final GET_CONSIGNMENT_TRACKING_STATUS =
    (clientId) => "/consignment/tracking/status/client/$clientId";
final GET_DISTRIBUTORS = (clientId) => '/hub/list/client/$clientId';
final REJECT_COMPLETED_TRIP_WITH_CONSIGNMENT_ID =
    (consignmentId) => '/consignment/$consignmentId/discard';

final GET_TRIPS_STATISTICS = (clientId) =>
    "/consignment/tracking/statistics/client/$clientId";
    
    final GET_UPCOMING_TRIPS_STATUS_LIST = (clientId, pageNumber) =>
    "/consignment/tracking/status/created/client/$clientId/page/$pageNumber";
final GET_ONGOING_TRIPS_STATUS_LIST = (clientId, pageNumber) =>
    "/consignment/tracking/status/ongoing/client/$clientId/page/$pageNumber";
final GET_COMPLETED_TRIPS_STATUS_LIST = (clientId, pageNumber) =>
    "/consignment/tracking/status/completed/client/$clientId/page/$pageNumber";
final GET_APPROVED_TRIPS_STATUS_LIST = (clientId, pageNumber) =>
    "/consignment/tracking/status/approved/client/$clientId/page/$pageNumber";
final GET_DISCARDED_TRIPS_STATUS_LIST = (clientId, pageNumber) =>
    "/consignment/tracking/status/discarded/client/$clientId/page/$pageNumber";

final GET_DRIVERS_LIST_PAGE_WISE =
    (pageIndex) => "/manager/driver/list/page/$pageIndex";

final GET_VEHICLES_LIST_PAGE_WISE =
    (pageIndex) => "/vehicle/list/page/$pageIndex";

final GET_ALL_HUBS_FOR_CLIENT =
    (clientId, pageNumber) => '/hub/list/client/$clientId/page/$pageNumber';

final CHECK_HUB_TITLE_CONTAINS =
    (hubTitle) => '/hub/title/contains/$hubTitle';


    
final GET_EXPESNE_PERIOD =
    (clientId) => '/expense/client/$clientId/period/list';

    const String GET_EXPENSES_TYPE = "/expense/type/list";
    const String GET_EXPENSES_AGGREGATE = "/expense/list/aggregate";
///////////////////////////////////////////////////////////////
