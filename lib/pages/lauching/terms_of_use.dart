import 'package:animations/animations.dart';
import 'package:baromaitre/pages/lauching/policy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "En créant un compte, vous consentez aux \n",
          style: Theme.of(context).textTheme.bodyText1,
          children: [
            TextSpan(
              text: "Termes & Conditions",
              style: TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showModal(
                    context: context,
                    configuration: FadeScaleTransitionConfiguration(),
                    builder: (context) {
                      return PolicyDialog(
                        mdFileName: 'terms_and_conditions.md',
                      );
                    },
                  );
                },
            ),
            TextSpan(text: " et "),
            TextSpan(
              text: "Politiques de confidentialité !",
              style: TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PolicyDialog(
                        mdFileName: 'privacy_policy.md',
                      );
                    },
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}