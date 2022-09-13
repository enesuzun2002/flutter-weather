import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/prefs_helper.dart';

class ApiKeySettingsDialog extends StatelessWidget {
  const ApiKeySettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController apiKeyEditingController =
        TextEditingController();
    String apiKey = "";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () async {
              apiKeyEditingController.text = PrefsHelper.apiKey;
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    contentPadding:
                        const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    title: Text(AppLocalizations.of(context)!.apiKeySH),
                    children: [
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.apiKeyHelp,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                autovalidateMode: AutovalidateMode.disabled,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: false,
                                  label: Text(
                                      AppLocalizations.of(context)!.apiKeyHint),
                                ),
                                autocorrect: false,
                                enableSuggestions: false,
                                controller: apiKeyEditingController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .apiKeyEmpty;
                                  } else if (value.length != 32) {
                                    return AppLocalizations.of(context)!
                                        .apiKeyInvalid;
                                  }
                                  return null;
                                },
                                onChanged: (value) => apiKey = value,
                              ),
                            ],
                          )),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            PrefsHelper.apiKey = apiKey;
                            PrefsHelper.updateValue(
                                PrefsHelper.keyApiKey, apiKey);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.okB),
                      )
                    ],
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.apiKeySH,
                        style: Theme.of(context).textTheme.subtitle1),
                    const SizedBox(height: 5.0),
                    Text(AppLocalizations.of(context)!.apiKeySD,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const Icon(Icons.api_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
