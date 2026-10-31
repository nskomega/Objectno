// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Objectno';

  @override
  String get saveFailure =>
      'Não foi possível guardar a alteração. Tente novamente.';

  @override
  String get appearance => 'Aparência';

  @override
  String get followSystem => 'Seguir o sistema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Escuro';

  @override
  String get objectsLoadFailure => 'Não foi possível carregar os imóveis';

  @override
  String get restartRetry => 'Reinicie a aplicação e tente novamente.';

  @override
  String get objectsHeading => 'Os seus imóveis';

  @override
  String get objectsIntro =>
      'Registe problemas, adicione fotos e acompanhe as correções.';

  @override
  String get emptyObjectsTitle => 'Adicione o seu primeiro imóvel';

  @override
  String get emptyObjectsBody =>
      'Adicione um apartamento, uma divisão ou outro imóvel a inspecionar.';

  @override
  String get createObject => 'Adicionar imóvel';

  @override
  String get newObject => 'Novo imóvel';

  @override
  String get objectName => 'Nome do imóvel';

  @override
  String get objectNameHint => 'Por exemplo, apartamento na Rua do Carvalho';

  @override
  String get cancel => 'Cancelar';

  @override
  String get create => 'Criar';

  @override
  String get deleteObjectTitle => 'Eliminar o imóvel?';

  @override
  String get deleteObjectBody =>
      'O imóvel, os seus problemas e as fotos serão eliminados deste dispositivo.';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteObject => 'Eliminar imóvel';

  @override
  String get issuesLoadFailure => 'Não foi possível carregar os problemas';

  @override
  String get reopenObject => 'Tente abrir o imóvel novamente.';

  @override
  String get issuesHeading => 'Problemas';

  @override
  String get filterAll => 'Todos';

  @override
  String get statusOpen => 'Aberto';

  @override
  String get statusDone => 'Corrigido';

  @override
  String get noIssuesTitle => 'Ainda não há problemas';

  @override
  String get noMatchesTitle => 'Ainda não há nada aqui';

  @override
  String get noIssuesBody =>
      'Adicione uma descrição e uma foto do que precisa de correção.';

  @override
  String get noMatchesBody => 'Tente escolher outro filtro.';

  @override
  String get issuePhoto => 'Foto do problema';

  @override
  String get photoLoadFailure => 'Não foi possível abrir a foto';

  @override
  String get reopenIssue => 'Reabrir';

  @override
  String get markDone => 'Marcar como corrigido';

  @override
  String get addIssue => 'Adicionar problema';

  @override
  String get newIssue => 'Novo problema';

  @override
  String get photoPickFailure =>
      'Não foi possível adicionar a foto. Verifique as permissões e escolha um ficheiro até 8 MB.';

  @override
  String get saveIssueFailure =>
      'Não foi possível guardar. O texto continua no formulário. Tente novamente.';

  @override
  String get pleaseWait => 'Aguarde…';

  @override
  String get saveIssue => 'Guardar problema';

  @override
  String get issueDescriptionLabel => 'O que precisa de correção?';

  @override
  String get issueDescriptionHint => 'Descreva o local e o problema';

  @override
  String get removePhoto => 'Remover foto';

  @override
  String get takePhoto => 'Tirar foto';

  @override
  String get fromGallery => 'Da galeria';

  @override
  String get localStorageNote =>
      'Os dados e as fotos são guardados neste dispositivo. A sincronização ainda não está disponível.';

  @override
  String get requiredField => 'Este campo é obrigatório';

  @override
  String get databaseOpenFailure => 'Não foi possível abrir os dados';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get language => 'Idioma da aplicação';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get account => 'Conta';

  @override
  String get signIn => 'Entrar';

  @override
  String get register => 'Criar conta';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Palavra-passe';

  @override
  String get signOut => 'Sair';

  @override
  String get deleteAccount => 'Eliminar conta';

  @override
  String get deleteAccountBody =>
      'Introduza a palavra-passe para eliminar permanentemente a conta e os seus dados neste dispositivo.';

  @override
  String get authUnavailable =>
      'O início de sessão está indisponível. Pode continuar a usar o diário local.';

  @override
  String get authFailure =>
      'Não foi possível concluir o pedido. Tente novamente.';

  @override
  String get authInvalidCredentials => 'Verifique o e-mail e a palavra-passe.';

  @override
  String get authPasswordRule =>
      'Use pelo menos 12 caracteres e no máximo 72 bytes UTF-8.';

  @override
  String get authNetwork => 'Falha na ligação. Tente novamente.';

  @override
  String get authStorage =>
      'O armazenamento seguro está indisponível. Tente novamente.';

  @override
  String get authLocalNote =>
      'Os dados ficam neste dispositivo; a sincronização está indisponível. Os registos de convidado ficam separados.';
}
