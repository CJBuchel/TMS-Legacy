import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tms/providers/local_storage_provider.dart';
import 'package:tms/utils/logger.dart';

// Shows a QR code other devices can scan to open the web client of the connected server
class FloatingQrButton extends StatelessWidget {
  const FloatingQrButton({super.key});

  void _displayServerQrCode(BuildContext context) {
    String addr = TmsLocalStorageProvider().serverAddress;
    String qrData = "$addr/ui";
    TmsLogger().i("Server QR data: $qrData");

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 300.0,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: Colors.red,
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      tooltip: "TMS Web QR code",
      onPressed: () => _displayServerQrCode(context),
      child: const Icon(Icons.qr_code_2_sharp, size: 48),
    );
  }
}
