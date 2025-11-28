import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/config/app/text_utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_widgets/real_state/models/entreprise.dart';
import 'package:my_widgets/real_state/models/message.dart';

class AiResume extends StatefulWidget {
  const AiResume({super.key, required this.entreprise});
  final RealEntreprise entreprise;

  @override
  State<AiResume> createState() => _AiResumeState();
}

class _AiResumeState extends State<AiResume> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RxList<ChatMessage> _chatHistory = <ChatMessage>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isInitializing = true.obs;

  List<Message> _allMessages = [];
  String? _apiKey;

  final List<String> _suggestions = [
    "Fais-moi un résumé des avis",
    "Quels sont les points positifs ?",
    "Quels sont les problèmes récurrents ?",
    "Donne-moi des suggestions d'amélioration",
  ];

  @override
  void initState() {
    super.initState();
    getGeminiApiKey();
    _fetchMessages();
  }

  Future<String?> getGeminiApiKey() async {
    var q = await DB.firestore(Collections.keys).doc('geminiApiKey').get();
    _apiKey = q != null ? q.data()!['key'] : null;
  }

  Future<void> _fetchMessages() async {
    try {
      var snapshot = await DB
          .firestore(Collections.entreprises)
          .doc(widget.entreprise.id)
          .collection(Collections.messages)
          .get();

      _allMessages =
          snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();

      // Add initial greeting
      _chatHistory.add(ChatMessage(
        text:
            "Bonjour ! Je suis votre assistant IA. J'ai analysé ${_allMessages.length} avis de votre entreprise. Comment puis-je vous aider ?",
        isUser: false,
      ));
    } catch (e) {
      print("Error fetching messages: $e");
      _chatHistory.add(ChatMessage(
        text:
            "Désolé, je n'ai pas pu récupérer les avis. Veuillez réessayer plus tard.",
        isUser: false,
      ));
    } finally {
      _isInitializing.value = false;
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _controller.clear();
    _chatHistory.add(ChatMessage(text: text, isUser: true));
    _scrollToBottom();
    _isLoading.value = true;

    try {
      final response = await _callGemini(text);
      _chatHistory.add(ChatMessage(text: response, isUser: false));
    } catch (e) {
      _chatHistory.add(ChatMessage(
        text: "Une erreur est survenue lors de l'analyse. Erreur: $e",
        isUser: false,
      ));
    } finally {
      _isLoading.value = false;
      _scrollToBottom();
    }
  }

  Future<String> _callGemini(String query) async {
    StringBuffer contextBuffer = StringBuffer();
    contextBuffer.writeln(
        "Voici les avis clients pour l'entreprise '${widget.entreprise.nom}':");

    // Take up to 50 most recent messages to fit in context window
    var messagesToAnalyze =
        _allMessages.length > 50 ? _allMessages.sublist(0, 50) : _allMessages;

    for (var msg in messagesToAnalyze) {
      contextBuffer.writeln("- [${msg.categorie}] ${msg.siege} ${msg.message}");
    }

    contextBuffer.writeln(
        "\nQuestion de l'utilisateur (Responsable de l'entreprise): $query");
    contextBuffer.writeln(
        "Tu es un assistant expert pour le chef d'entreprise. Ton rôle est de fournir des informations stratégiques et utiles pour la gestion de son établissement. "
        "Réponds de manière professionnelle, concise et orientée action, comme si tu t'adressais à un décideur. Soit bref et va à l'essentiel"
        "Base-toi UNIQUEMENT sur les avis ci-dessus.");

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": contextBuffer.toString()}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'];
      }
    }

    return "Je n'ai pas pu générer de réponse. Code erreur: ${response.statusCode}\n\nDétails: ${response.body}";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Assets.icons("ai.png"), height: 28, width: 28),
            const SizedBox(width: 12),
            EText("Assistant IA",
                size: 20, weight: FontWeight.bold, color: Colors.black),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          final contentWidth = isWide ? 900.0 : constraints.maxWidth;

          return Center(
            child: Container(
              width: contentWidth,
              decoration: isWide
                  ? BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade200),
                        right: BorderSide(color: Colors.grey.shade200),
                      ),
                    )
                  : null,
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (_isInitializing.value) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.staggeredDotsWave(
                                  color: AppColors.color500, size: 40),
                              const SizedBox(height: 16),
                              EText("Analyse des avis en cours...",
                                  color: Colors.grey),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            _chatHistory.length + (_isLoading.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _chatHistory.length) {
                            return _buildLoadingBubble();
                          }
                          return _buildChatBubble(
                              _chatHistory[index], contentWidth);
                        },
                      );
                    }),
                  ),

                  // Suggestions
                  Obx(() => !_isLoading.value && _chatHistory.length <= 1
                      ? Container(
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ActionChip(
                                  label: Text(_suggestions[index]),
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  elevation: 1,
                                  labelStyle: TextStyle(
                                      color: AppColors.color500, fontSize: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                        color: AppColors.color500
                                            .withOpacity(0.2)),
                                  ),
                                  onPressed: () =>
                                      _sendMessage(_suggestions[index]),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink()),

                  // Input Area
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border(top: BorderSide(color: Colors.grey.shade100)),
                      boxShadow: isWide
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F3F4),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText:
                                      "Posez une question sur vos avis...",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                ),
                                onSubmitted: _sendMessage,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Obx(() => Container(
                                decoration: BoxDecoration(
                                  color: _isLoading.value
                                      ? Colors.grey
                                      : AppColors.color500,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.send_rounded,
                                      color: Colors.white, size: 20),
                                  onPressed: _isLoading.value
                                      ? null
                                      : () => _sendMessage(_controller.text),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, double parentWidth) {
    // Use a percentage of the parent width, but cap it for readability
    final maxBubbleWidth = parentWidth * 0.75;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.color500 : const Color(0xFFF1F3F4),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isUser ? 20 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(Assets.icons("ai.png"),
                        height: 14, width: 14),
                  ),
                  const SizedBox(width: 8),
                  EText("Assistant",
                      size: 13, weight: FontWeight.bold, color: Colors.black87),
                ],
              ),
              const SizedBox(height: 8),
            ],
            TextUtils.buildFormattedText(
              message.text,
              color: message.isUser ? Colors.white : const Color(0xFF2D3436),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F4),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: LoadingAnimationWidget.waveDots(
            color: AppColors.color500, size: 20),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
