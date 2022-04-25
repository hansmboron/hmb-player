import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hmbplayer/models/audio_model.dart';
import './upload_controller.dart';
import 'widgets/dropdown_widget.dart';

class UploadPage extends GetView<UploadController> {
  UploadPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Audio'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding:
            EdgeInsets.symmetric(vertical: 12, horizontal: _size.width * 0.04),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: double.maxFinite,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.audiotrack),
                  onPressed: controller.pickAudio,
                  label: const Text('Selecione Audio'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Text("Audio: ${controller.audioSelected.value}")),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.nameEC,
                autocorrect: true,
                maxLength: 100,
                decoration: InputDecoration(
                  counterText: '',
                  labelText: 'Nome *',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.authorEC,
                autocorrect: true,
                maxLength: 100,
                decoration: InputDecoration(
                  counterText: '',
                  labelText: 'Author *',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => DropdownWidget(
                  onChanged: (value) {
                    controller.playSelected.value = value!;
                  },
                  value: controller.playSelected.value,
                  items: controller.playlists.map(
                    (p) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          p?.title ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        value: p?.id ?? '',
                        onTap: () {
                          controller.playSelected.value = p?.id ?? 'Rock';
                        },
                      );
                    },
                  ).toList(),
                  hint: 'Selecione Playlist',
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.audioSelected.value == ''
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            AudioModel audio = AudioModel(
                              title: controller.nameEC.text,
                              author: controller.authorEC.text,
                            );
                            controller.addAudio(audio);
                          }
                        },
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
