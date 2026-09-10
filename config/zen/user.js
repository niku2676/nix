// Only stable, user-chosen privacy settings are kept here. Dynamic profile
// data, history, cookies, device IDs, sessions and extension storage are not.

user_pref("browser.contentblocking.category", "standard");
user_pref("browser.download.deletePrivate.chosen", true);
user_pref("browser.newtab.privateAllowed", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.prefetch-next", false);
user_pref("privacy.clearOnShutdown_v2.formdata", true);
