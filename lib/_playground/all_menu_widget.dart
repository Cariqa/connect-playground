import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:connect_reference_client/_playground/docs_button.dart';
import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:connect_reference_client/_playground/menu_item_widget.dart';
import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/playground.dart';
import 'package:connect_reference_client/_playground/util.dart';
import 'package:connect_reference_client/modules/1_create_user.dart';
import 'package:connect_reference_client/modules/1_get_all_users.dart';
import 'package:connect_reference_client/modules/1_get_user.dart';
import 'package:connect_reference_client/modules/1_soft_delete_user.dart';
import 'package:connect_reference_client/modules/1_update_user.dart';
import 'package:connect_reference_client/modules/2_add_payment_method.dart';
import 'package:connect_reference_client/modules/2_delete_payment_methods.dart';
import 'package:connect_reference_client/modules/2_get_payment_methods.dart';
import 'package:connect_reference_client/modules/2_set_payment_method_default.dart';
import 'package:connect_reference_client/modules/3_add_billing_details.dart';
import 'package:connect_reference_client/modules/3_get_billing_details.dart';
import 'package:connect_reference_client/modules/4_get_partners_list.dart';
import 'package:connect_reference_client/modules/4_get_stations_details.dart';
import 'package:connect_reference_client/modules/4_get_stations_list.dart';
import 'package:connect_reference_client/modules/4_get_stations_tiles.dart';
import 'package:connect_reference_client/modules/5_get_all_charging_sessions.dart';
import 'package:connect_reference_client/modules/5_get_charging_session.dart';
import 'package:connect_reference_client/modules/5_rate_charging_session.dart';
import 'package:connect_reference_client/modules/5_start_charging.dart';
import 'package:connect_reference_client/modules/5_stop_charging.dart';
import 'package:connect_reference_client/modules/6_load_invoices.dart';
import 'package:connect_reference_client/modules/7_get_unpaid_sessions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllMenuWidget extends StatefulWidget {
  const AllMenuWidget({super.key});

  @override
  State<AllMenuWidget> createState() => _AllMenuWidgetState();
}

class _AllMenuWidgetState extends State<AllMenuWidget> {
  final scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAllMenuWidget(context: context, scrollController: scrollController);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final modules = <AppTab, Widget>{
    AppTab.createUser: CreateUser(),
    AppTab.getUser: GetUser(),
    AppTab.updateUser: UpdateUser(),
    AppTab.getAllUsers: GetAllUsers(),
    AppTab.softDeleteUser: SoftDeleteUser(),
    AppTab.addPaymentMethod: AddPaymentMethod(),
    AppTab.setPaymentMethodDefault: SetPaymentMethodDefault(),
    AppTab.updateBillingDetails: UpdateBillingDetails(),
    AppTab.getBillingDetails: GetBillingDetails(),
    AppTab.getPaymentMethods: GetPaymentMethods(),
    AppTab.deletePaymentMethod: DeletePaymentMethod(),
    AppTab.getStationsTiles: GetStationsTiles(),
    AppTab.getStationsList: GetStationsList(),
    AppTab.getStationDetails: GetStationDetails(),
    AppTab.getPartnersList: GetPartnersList(),
    AppTab.startCharging: StartCharging(),
    AppTab.getChargingSession: GetChargingSession(),
    AppTab.stopCharging: StopCharging(),
    AppTab.rateChargingSession: RateChargingSession(),
    AppTab.getAllChargingSessions: GetAllChargingSessions(),
    AppTab.getUnpaidSessions: GetUnpaidSessions(),
    AppTab.getInvoices: GetInvoices(),
  };

  @override
  Widget build(BuildContext context) {
    final currentAppTab = context.select((PlaygroundCubit cubit) => cubit.state.appTab);

    final widthMenu = isMobile ? MediaQuery.sizeOf(context).width : 260.0;
    final currentAppTabIndex = modules.entries.toList().indexWhere(((e) => e.key == currentAppTab));

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: widthMenu,
                height: MediaQuery.sizeOf(context).height * 0.82,
                child: Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(14, 0, 20, 0),
                        controller: scrollController,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ChapterWidget(
                              title: '1  Users',
                              appChapter: AppChapter.user,
                              submodules: [
                                MenuItemWidget(
                                  title: 'Create user',
                                  appTab: AppTab.createUser,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Get user',
                                  appTab: AppTab.getUser,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Update user',
                                  appTab: AppTab.updateUser,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Get all users',
                                  appTab: AppTab.getAllUsers,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Soft delete user',
                                  appTab: AppTab.softDeleteUser,
                                  currentAppTab: currentAppTab,
                                ),
                              ],
                            ),
                            ChapterWidget(
                              title: '2  Payment',
                              appChapter: AppChapter.payment,
                              submodules: [
                                MenuItemWidget(
                                  title: 'Add payment method',
                                  appTab: AppTab.addPaymentMethod,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Get all payment methods',
                                  appTab: AppTab.getPaymentMethods,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Set payment method as default',
                                  appTab: AppTab.setPaymentMethodDefault,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Delete payment method',
                                  appTab: AppTab.deletePaymentMethod,
                                  currentAppTab: currentAppTab,
                                ),
                              ],
                            ),
                            ChapterWidget(
                              title: '3  Billing details',
                              appChapter: AppChapter.billing,
                              submodules: [
                                MenuItemWidget(
                                  title: 'Update billing details',
                                  appTab: AppTab.updateBillingDetails,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Get billing details',
                                  appTab: AppTab.getBillingDetails,
                                  currentAppTab: currentAppTab,
                                ),
                              ],
                            ),
                            ChapterWidget(
                              title: '4  Stations',
                              appChapter: AppChapter.stations,
                              submodules: [
                                MenuItemWidget(
                                  title: 'Get stations tile',
                                  appTab: AppTab.getStationsTiles,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Get stations around list',
                                  appTab: AppTab.getStationsList,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Get station details',
                                  appTab: AppTab.getStationDetails,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Get partners list',
                                  appTab: AppTab.getPartnersList,
                                  currentAppTab: currentAppTab,
                                ),
                              ],
                            ),
                            ChapterWidget(
                              title: '5  Charging',
                              appChapter: AppChapter.charging,
                              submodules: [
                                MenuItemWidget(
                                  title: 'Start charging',
                                  appTab: AppTab.startCharging,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Load session details',
                                  appTab: AppTab.getChargingSession,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Stop charging session',
                                  appTab: AppTab.stopCharging,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Rate charging session',
                                  appTab: AppTab.rateChargingSession,
                                  currentAppTab: currentAppTab,
                                ),
                                MenuItemWidget(
                                  title: 'Load all sessions',
                                  appTab: AppTab.getAllChargingSessions,
                                  currentAppTab: currentAppTab,
                                ),
                              ],
                            ),
                            ChapterWidget(
                              title: '6  Invoices',
                              appChapter: AppChapter.invoices,
                              submodules: [
                                MenuItemWidget(
                                  title: 'Load invoices',
                                  appTab: AppTab.getInvoices,
                                  currentAppTab: currentAppTab,
                                ),
                              ],
                            ),
                            ChapterWidget(
                              title: '7  Debts',
                              appChapter: AppChapter.debt,
                              submodules: [
                                MenuItemWidget(
                                  title: 'Load unpaid charges',
                                  appTab: AppTab.getUnpaidSessions,
                                  currentAppTab: currentAppTab,
                                ),
                              ],
                            ),
                            SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                    ListenableBuilder(
                      listenable: scrollController,
                      builder: (context, child) {
                        if (scrollController.position.hasContentDimensions &&
                            scrollController.position.maxScrollExtent != 0 &&
                            scrollController.position.pixels != scrollController.position.maxScrollExtent) {
                          return Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 20,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: menuShadowGradient(Theme.of(context).primaryColor),
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              width: widthMenu,
              decoration: BoxDecoration(color: dividerColor),
            ),
            SizedBox(height: 20),
            DocsButton(),
          ],
        ),
        Expanded(
          child: BlocListener<PlaygroundCubit, PlaygroundState>(
            listener: (context, state) {
              if (isMobile && state.appTab != AppTab.none) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => modules.entries.firstWhere(((e) => e.key == state.appTab)).value),
                );
              }
            },
            child: isMobile
                ? SizedBox()
                : SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.87,
                    child: IndexedStack(
                      index: currentAppTabIndex,
                      children: modules.values.toList(),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
