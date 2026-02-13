// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get bottom_home_page => 'Accueil';

  @override
  String get bottom_setting_page => 'Paramètres';

  @override
  String get start_initialization_starting => 'Initialisation, veuillez patienter...';

  @override
  String get start_initialization_loadingData => 'Récupération des données...';

  @override
  String get start_initialization_complete => 'Initialisation terminée';

  @override
  String get start_initialization_unknown => 'Initialisation en cours avec un statut inconnu...';

  @override
  String get account_settings => 'Paramètres du compte';

  @override
  String get email_address => 'Adresse e-mail';

  @override
  String get modify_login_email => 'Modifier l\"e-mail de connexion';

  @override
  String get login_password => 'Mot de passe de connexion';

  @override
  String get modify_account_password => 'Modifier le mot de passe du compte';

  @override
  String get bank_card_number => 'Numéro de carte bancaire';

  @override
  String get bank_card_tail_number => 'Numéro de fin 6789';

  @override
  String get manage_payment_info => 'Gérer les informations de paiement';

  @override
  String get app_settings => 'Paramètres de l\"application';

  @override
  String get language_settings => 'Paramètres de langue';

  @override
  String get select_app_language => 'Sélectionner la langue de l\"application';

  @override
  String get logout_account => 'Déconnexion du compte';

  @override
  String get login_account => 'Connexion au compte';

  @override
  String get exit_current_account => 'Quitter le compte actuel';

  @override
  String get login_your_account => 'Connectez-vous à votre compte';

  @override
  String get privacy_policy => 'Politique de confidentialité';

  @override
  String get view_app_privacy_terms => 'Voir les conditions de confidentialité de l\"application';

  @override
  String get about_app => 'À propos de l\"application';

  @override
  String get version_info_and_help => 'Informations sur la version et aide';

  @override
  String get please_login_to_view_account_info => 'Veuillez vous connecter pour voir les informations du compte';

  @override
  String get please_login_first => 'Veuillez d\"abord vous connecter';

  @override
  String get privacy_policy_page_under_development => 'Page de politique de confidentialité en cours de développement';

  @override
  String get about_page_under_development => 'Page À propos en cours de développement';

  @override
  String get select_language => 'Sélectionner la langue';

  @override
  String get language_switched_to => 'Langue changée en';

  @override
  String get app_name => 'Refundo';

  @override
  String get app_slogan => 'Système intelligent de gestion des remboursements';

  @override
  String get starting_initialization => 'Démarrage de l\'initialisation...';

  @override
  String get loading_user_data => 'Chargement des données utilisateur...';

  @override
  String get unknown_error => 'Erreur inconnue';

  @override
  String get ready => 'Prêt...';

  @override
  String get initializing => 'Initialisation en cours...';

  @override
  String get orders => 'Commandes';

  @override
  String get refunds => 'Remboursements';

  @override
  String get manage_orders => 'Gérer les commandes';

  @override
  String get cancel => 'Annuler';

  @override
  String get refund => 'Rembourser';

  @override
  String get select_at_least_one_order => 'Veuillez sélectionner au moins une commande';

  @override
  String get refund_success_waiting_approval => 'Remboursement réussi, veuillez attendre l\'approbation';

  @override
  String get server_error => 'Erreur serveur';

  @override
  String get error => 'Erreur';

  @override
  String get total_amount => 'Montant total';

  @override
  String get today_orders => 'jour';

  @override
  String get processing => 'En traitement';

  @override
  String get camera_permission_required => 'Autorisation caméra requise';

  @override
  String get camera_permission_description => 'La fonction de numérisation nécessite l\'accès à votre caméra. Veuillez activer l\'autorisation caméra pour l\'application dans les paramètres système.';

  @override
  String get go_to_settings => 'Aller aux paramètres';

  @override
  String get notification => 'Notification';

  @override
  String get confirm => 'Confirmer';

  @override
  String get select_all => 'Tout sélectionner';

  @override
  String selected_count(Object selectedCount, Object total) {
    return 'Sélectionné $selectedCount/$total';
  }

  @override
  String get select_orders_to_refund => 'Sélectionnez les commandes à rembourser';

  @override
  String get no_orders => 'Aucune commande';

  @override
  String get order_list_empty => 'La liste des commandes est vide';

  @override
  String get order_number => 'Numéro de commande';

  @override
  String get time => 'Heure';

  @override
  String get refundable => 'Remboursable';

  @override
  String get no_withdrawal_records => 'Aucun historique de retrait';

  @override
  String get withdrawal_records_will_appear_here => 'Les historiques de retrait apparaîtront ici';

  @override
  String get withdrawal_application => 'Demande de retrait';

  @override
  String get completed => 'Terminé';

  @override
  String get pending => 'En attente';

  @override
  String get withdrawal_details => 'Détails du retrait';

  @override
  String get withdrawal_amount => 'Montant du retrait';

  @override
  String get application_time => 'Heure de la demande';

  @override
  String get processing_status => 'Statut du traitement';

  @override
  String get payment_method => 'Méthode de paiement';

  @override
  String get bank_card => 'Carte bancaire';

  @override
  String get close => 'Fermer';

  @override
  String get uid_label => 'UID';

  @override
  String get not_logged_in => 'Non connecté';

  @override
  String get please_login_to_view_profile => 'Veuillez vous connecter pour voir le profil';

  @override
  String get card_change_title => 'Modifier la carte bancaire';

  @override
  String get enter_email => 'Entrez l\'email';

  @override
  String get enter_password => 'Entrez le Mot de Passe';

  @override
  String get enter_new_card_number => 'Entrez le nouveau numéro de carte';

  @override
  String get please_enter_complete_info => 'Veuillez saisir des informations complètes';

  @override
  String get verification_success => 'Vérification réussie';

  @override
  String get email_or_password_incorrect => 'Email ou mot de passe incorrect';

  @override
  String get verification_failed => 'Échec de la vérification';

  @override
  String get please_enter_card_number => 'Veuillez saisir le numéro de carte';

  @override
  String get modification_success => 'Modification réussie';

  @override
  String get modification_failed => 'Échec de la modification';

  @override
  String get email_change_title => 'Modifier l\'email';

  @override
  String get enter_old_email => 'Entrez l\'ancien email';

  @override
  String get enter_new_email => 'Entrez le nouvel email';

  @override
  String get please_enter_new_email => 'Veuillez saisir un nouvel email';

  @override
  String get invalid_email_format => 'Format d\'email invalide';

  @override
  String get user_registration => 'Inscription Utilisateur';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get email => 'Email';

  @override
  String get verification_code => 'Code de vérification';

  @override
  String get get_verification_code => 'Obtenir le code';

  @override
  String countdown_seconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get password => 'Mot de passe';

  @override
  String get confirm_password => 'Confirmer le mot de passe';

  @override
  String get register => 'S\'inscrire';

  @override
  String get already_have_account => 'Vous avez déjà un compte?';

  @override
  String get login_now => 'Se connecter maintenant';

  @override
  String get please_enter_username => 'Veuillez entrer un nom d\'utilisateur';

  @override
  String get please_enter_valid_email => 'Veuillez entrer une adresse email valide';

  @override
  String get please_enter_verification_code => 'Veuillez entrer le code de vérification';

  @override
  String get password_length_at_least_6 => 'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get passwords_do_not_match => 'Les mots de passe ne correspondent pas';

  @override
  String get verification_code_send_failed => 'Échec de l\'envoi du code de vérification, veuillez réessayer';

  @override
  String get user_login => 'Connexion Utilisateur';

  @override
  String get username_or_email => 'Nom d\'utilisateur/Email';

  @override
  String get remember_me => 'Se souvenir de moi';

  @override
  String get forgot_password => 'Mot oublié?';

  @override
  String get login => 'Se connecter';

  @override
  String get no_account_register_now => 'Pas de compte? Inscrivez-vous maintenant';

  @override
  String get please_enter_username_and_password => 'Veuillez saisir le nom d\'utilisateur et le mot de passe';

  @override
  String get audit => 'Vérification';

  @override
  String get audit_page => 'Page de vérification';

  @override
  String get audit_records => 'Enregistrements de vérification';

  @override
  String get detail_info => 'Informations détaillées';

  @override
  String get user_id => 'ID utilisateur';

  @override
  String get nickname => 'Pseudonyme';

  @override
  String get refund_time => 'Heure de remboursement';

  @override
  String get refund_method => 'Méthode de remboursement';

  @override
  String get refund_amount => 'Montant du remboursement';

  @override
  String get approve => 'Approuver';

  @override
  String get reject => 'Rejeter';

  @override
  String get approved => 'Approuvé';

  @override
  String get rejected => 'Rejeté';

  @override
  String get items => 'éléments';

  @override
  String get no_audit_records => 'Aucun enregistrement de vérification';

  @override
  String get select_record_to_view => 'Sélectionnez un enregistrement pour voir les détails';

  @override
  String get already_approved => 'Déjà approuvé';

  @override
  String get already_rejected => 'Déjà rejeté';

  @override
  String get approve_success => 'Approbation réussie';

  @override
  String get approve_failed => 'Échec de l\'approbation';

  @override
  String get reject_success => 'Rejet réussi';

  @override
  String get reject_failed => 'Échec du rejet';

  @override
  String get filter_conditions => 'Critères de Filtrage';

  @override
  String get time_range => 'Période de Temps';

  @override
  String get all => 'Tous';

  @override
  String get one_day => 'Dernières 24 Heures';

  @override
  String get one_week => 'La Semaine Dernière';

  @override
  String get one_month => 'Le Mois Dernier';

  @override
  String get approval_status => 'Statut d\'Approba tion';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get no_records_found => 'Aucun enregistrement correspondant trouvé';

  @override
  String get adjust_filters => 'Veuillez essayer d\'ajuster les critères de filtrage';

  @override
  String get not_manager => 'Vous n\'êtes pas administrateur.';

  @override
  String get refund_confirmation => 'Confirmation de remboursement';

  @override
  String total_amount_orders(Object selectedCount, Object totalAmount) {
    return 'Total: $totalAmount FCFA | $selectedCount commandes';
  }

  @override
  String get select_payment_method => 'Sélectionner le mode de paiement';

  @override
  String get phone_payment => 'Paiement par téléphone';

  @override
  String get sanke_money => 'Argent Sank';

  @override
  String get wave_payment => 'Paiement WAVE';

  @override
  String get enter_phone_number => 'Entrez le numéro de téléphone';

  @override
  String get invalid_phone_format => 'Format de numéro de téléphone invalide';

  @override
  String get enter_sanke_account => 'Entrez le compte Sank Money';

  @override
  String get account_length_at_least_6 => 'Le compte doit contenir au moins 6 caractères';

  @override
  String get enter_wave_account => 'Entrez l\'ID du compte WAVE';

  @override
  String get wave_account_start_with_wave => 'L\'ID du compte WAVE doit commencer par WAVE';

  @override
  String get confirm_phone_number => 'Confirmer le numéro de téléphone';

  @override
  String get confirm_refund => 'Confirmer le remboursement';

  @override
  String get scan_the_QR => 'Scannez le QR code';

  @override
  String get order_less_than_5_months => 'La commande a moins de 5 mois.';

  @override
  String get total_amount_less_than_5000 => 'Le montant total de la commande est inférieur à 5 000.';

  @override
  String get change_name => 'Changer le nom';

  @override
  String get save => 'Enregistrer';

  @override
  String get new_name => 'Nouveau nom';

  @override
  String get please_enter_name => 'Veuillez entrer un nom';

  @override
  String get update_success => 'Modification réussie';

  @override
  String get callback_password => 'Récupérer le mot de passe';

  @override
  String get hint_enter_email => 'Veuillez entrer l\'e-mail';

  @override
  String get next_step => 'Suivant';

  @override
  String get hint_enter_verification_code => 'Veuillez entrer le code de vérification';

  @override
  String get resend_verification_code => 'Renvoyer';

  @override
  String resend_with_countdown(Object count) {
    return 'Renvoyer ($count)';
  }

  @override
  String get please_enter_code_first => 'Veuillez d\'abord entrer le code de vérification';

  @override
  String get verification_code_expired => 'Code de vérification expiré, veuillez renvoyer';

  @override
  String get verification_code_correct => 'Code de vérification correct';

  @override
  String get verification_code_incorrect => 'Code de vérification incorrect';

  @override
  String get invalid_request_format => 'Format de requête invalide';

  @override
  String get verification_service_unavailable => 'Service de vérification temporairement indisponible, veuillez réessayer plus tard';

  @override
  String get please_get_code_first => 'Veuillez d\'abord obtenir le code de vérification';

  @override
  String get verification_code_sent => 'Le code de vérification a été envoyé à votre e-mail';

  @override
  String get verification_code_sent_success => 'Code de vérification envoyé avec succès';

  @override
  String get email_send_failed => 'Échec de l\'envoi de l\'e-mail, veuillez vérifier l\'adresse e-mail ou réessayer plus tard';

  @override
  String get user_info_not_unique => 'Informations utilisateur non uniques, veuillez contacter le service client';

  @override
  String get no_user_found_for_email => 'Aucun compte utilisateur trouvé associé à cet e-mail';

  @override
  String get email_service_unavailable => 'Service e-mail temporairement indisponible, veuillez réessayer plus tard';

  @override
  String get send_failed => 'Échec de l\'envoi';

  @override
  String get set_new_password => 'Définir un nouveau mot de passe';

  @override
  String get new_password => 'Nouveau Mot de Passe';

  @override
  String get hint_enter_new_password => 'Veuillez entrer le nouveau mot de passe';

  @override
  String get hint_confirm_new_password => 'Veuillez entrer à nouveau le nouveau mot de passe';

  @override
  String get password_set_success => 'Mot de passe défini avec succès';

  @override
  String get sync_offline_orders => 'Sync Offline Orders';

  @override
  String get no_offline_orders => 'No offline orders to sync';

  @override
  String get syncing_offline_orders => 'Syncing offline orders...';

  @override
  String get sync_completed => 'Sync completed';

  @override
  String get orders_successfully => 'orders successfully';

  @override
  String get orders_failed => 'orders failed';

  @override
  String get sync_failed => 'Sync failed';

  @override
  String get sync_error => 'Sync error';

  @override
  String get failed_to_load_data => 'Échec du chargement des données';

  @override
  String get statistics => 'Statistiques';

  @override
  String get profile => 'Profil';

  @override
  String get total_orders => 'Total des commandes';

  @override
  String get balance => 'Solde';

  @override
  String get total => 'Total';

  @override
  String get in_review => 'En révision';

  @override
  String submit_for_approval(Object count) {
    return 'Soumettre pour approbation ($count)';
  }

  @override
  String get deselect_all => 'Tout désélectionner';

  @override
  String get scan_to_add => 'Scanner pour ajouter';

  @override
  String selected_orders_count(Object count) {
    return '$count commandes sélectionnées';
  }

  @override
  String estimated_refund(Object amount) {
    return 'Remboursement estimé: $amount FCFA';
  }

  @override
  String order_number_with_hash(Object number) {
    return 'Commande #$number';
  }

  @override
  String refund_amount_with_currency(Object amount) {
    return 'Remboursement: $amount FCFA';
  }

  @override
  String order_amount_with_currency(Object amount) {
    return 'Commande: $amount FCFA';
  }

  @override
  String get order_details => 'Détails de la commande';

  @override
  String get refund_details => 'Détails du remboursement';

  @override
  String get product_id => 'ID du produit';

  @override
  String get order_id_label => 'ID de commande';

  @override
  String get creation_time => 'Date de création';

  @override
  String get order_status_label => 'Statut de la commande';

  @override
  String get refund_account => 'Compte de remboursement';

  @override
  String get approval_status_label => 'Statut d\'approbation';

  @override
  String get refundable_status => 'Remboursable';

  @override
  String get needs_multi_select => 'Nécessite une sélection multiple';

  @override
  String get not_refundable => 'Non remboursable';

  @override
  String get already_refunded => 'Déjà remboursé';

  @override
  String wait_months(Object months) {
    return 'Attendre $months mois';
  }

  @override
  String get insufficient_amount_need_more => 'Montant insuffisant, besoin de plus';

  @override
  String get got_it => 'Compris';

  @override
  String get insufficient_refund_amount_error => 'Le montant de remboursement de la commande est inférieur à 5000 FCFA, veuillez sélectionner plusieurs commandes pour un remboursement cumulatif';

  @override
  String cumulative_amount_insufficient(Object amount) {
    return 'Le montant de remboursement cumulatif est inférieur à 5000 FCFA, au moins $amount FCFA de plus nécessaires. Veuillez sélectionner plus de commandes.';
  }

  @override
  String get contains_non_refundable_orders => 'Les commandes sélectionnées contiennent des commandes non remboursables, veuillez vérifier votre sélection';

  @override
  String get calculating_refund_amount => 'Calcul du montant de remboursement...';

  @override
  String get submitting_refund_application => 'Soumission de la demande de remboursement...';

  @override
  String get refund_application_submitted => 'Demande de remboursement soumise avec succès!';

  @override
  String get network_error_check_connection => 'Erreur réseau, veuillez vérifier votre connexion';

  @override
  String get order_needs_5_months => 'La commande doit avoir 5 mois pour être éligible au remboursement';

  @override
  String get refund_amount_less_than_5000 => 'Le montant de remboursement de la commande est inférieur à 5000, ne répond pas aux conditions de remboursement';

  @override
  String get please_select_orders_first => 'Veuillez d\'abord sélectionner les commandes à rembourser';

  @override
  String refund_failed_with_code(Object code) {
    return 'Échec de la demande de remboursement, code d\'erreur: $code';
  }

  @override
  String get select_refund_method => 'Sélectionner la méthode de remboursement';

  @override
  String order_count_label(Object count) {
    return 'Nombre de commandes: $count';
  }

  @override
  String total_refund_amount_label(Object amount) {
    return 'Remboursement total: $amount FCFA';
  }

  @override
  String get refund_method_label => 'Méthode de remboursement:';

  @override
  String get refund_account_optional => 'Compte de remboursement (optionnel)';

  @override
  String get submit => 'Soumettre';

  @override
  String get direct_submit_approval => 'Soumettre directement pour approbation';

  @override
  String get orange_money => 'Orange Money';

  @override
  String get wave => 'Wave';

  @override
  String get phone_number_label => 'Numéro de téléphone';

  @override
  String get data_statistics => 'Statistiques des données';

  @override
  String get order_heatmap => 'Carte thermique des commandes';

  @override
  String get detailed_statistics => 'Statistiques détaillées';

  @override
  String get average_order_amount => 'Montant moyen des commandes';

  @override
  String get max_order_amount => 'Montant maximal des commandes';

  @override
  String get total_orders_count => 'Nombre total de commandes';

  @override
  String get weekday_mon => 'Lun';

  @override
  String get weekday_tue => 'Mar';

  @override
  String get weekday_wed => 'Mer';

  @override
  String get weekday_thu => 'Jeu';

  @override
  String get weekday_fri => 'Ven';

  @override
  String get weekday_sat => 'Sam';

  @override
  String get weekday_sun => 'Dim';

  @override
  String get heatmap_few => 'Peu';

  @override
  String get heatmap_medium => 'Moyen';

  @override
  String get heatmap_many => 'Beaucoup';

  @override
  String get heatmap_many_many => 'Très beaucoup';

  @override
  String get guest_user => 'Utilisateur invité';

  @override
  String version_info(Object build, Object version) {
    return 'Version $version ($build)';
  }

  @override
  String get main_features => 'Fonctionnalités principales';

  @override
  String get open_source_license => 'Licence open source';

  @override
  String get view_third_party_licenses => 'Voir les licences tiers';

  @override
  String get quick_links => 'Liens rapides';

  @override
  String get feature_scan_orders => 'Scanner pour ajouter des commandes';

  @override
  String get feature_manage_orders => 'Gestion et filtrage des commandes';

  @override
  String get feature_smart_refund => 'Système de remboursement intelligent';

  @override
  String get feature_data_statistics => 'Statistiques et analyse des données';

  @override
  String last_updated_date(Object date) {
    return 'Dernière mise à jour: $date';
  }

  @override
  String get invalid_qr_code => 'Code QR invalide';

  @override
  String get illegal_qr_content => 'Contenu QR illégal';

  @override
  String get qr_content_not_json => 'Le contenu QR n\'est pas un format JSON valide';

  @override
  String get statistical_analysis => 'Analyse statistique';

  @override
  String get this_week => 'Cette semaine';

  @override
  String get this_month => 'Ce mois';

  @override
  String get this_quarter => 'Ce trimestre';

  @override
  String get this_year => 'Cette année';

  @override
  String get orders_count => 'commandes';

  @override
  String get fcfa => 'FCFA';

  @override
  String get order_statistics => 'Statistiques des commandes';

  @override
  String get refund_statistics => 'Statistiques de remboursement';

  @override
  String get smart_refund_management_system => 'Système intelligent de gestion des remboursements';

  @override
  String get refundo_app_name => 'RefundO';

  @override
  String get all_rights_reserved => 'Tous droits réservés';

  @override
  String get scan_history => 'Historique des scans';

  @override
  String get view_scan_history => 'Voir l\'historique des scans';

  @override
  String get help_and_feedback => 'Aide et commentaires';

  @override
  String get faq => 'FAQ';

  @override
  String get clear_all => 'Tout effacer';

  @override
  String get delete => 'Supprimer';

  @override
  String get product_details => 'Détails du produit';

  @override
  String get price => 'Prix';

  @override
  String get refund_percent => 'Pourcentage de remboursement';

  @override
  String get rescan => 'Rescanner';

  @override
  String get delete_history_item => 'Supprimer l\'élément de l\'historique';

  @override
  String get confirm_delete_scan_history => 'Confirmer la suppression de cet historique de scan?';

  @override
  String get clear_all_history => 'Effacer tout l\'historique';

  @override
  String get confirm_clear_all_history => 'Confirmer l\'effacement de tout l\'historique des scans?';

  @override
  String get deleted_successfully => 'Supprimé avec succès';

  @override
  String get history_cleared => 'Historique effacé';

  @override
  String get no_scan_history => 'Aucun historique de scan';

  @override
  String get scan_products_to_see_history => 'Scannez des produits pour voir l\'historique ici';

  @override
  String get rescan_function_coming_soon => 'Fonction de rescan imminent';

  @override
  String get privacy_policy_title => 'Politique de confidentialité';

  @override
  String get info_collection => 'Collecte d\'informations';

  @override
  String get info_collection_1 => 'Nous collectons les types d\'informations suivants:';

  @override
  String get info_collection_2 => '• Informations personnelles: Y compris le nom, l\'adresse e-mail, le numéro de téléphone et les informations de carte bancaire';

  @override
  String get info_collection_3 => '• Informations de commande: Y compris les enregistrements d\'achat, les demandes de remboursement et l\'historique des transactions';

  @override
  String get info_collection_4 => '• Données d\'utilisation: Y compris l\'utilisation de l\'application et les préférences';

  @override
  String get info_collection_5 => '• Informations sur l\'appareil: Y compris le modèle d\'appareil, la version du système d\'exploitation et l\'identifiant unique';

  @override
  String get info_usage => 'Utilisation des informations';

  @override
  String get info_usage_1 => 'Nous utilisons les informations collectées pour:';

  @override
  String get info_usage_2 => '• Traiter vos commandes et demandes de remboursement';

  @override
  String get info_usage_3 => '• Améliorer nos services et fonctionnalités';

  @override
  String get info_usage_4 => '• Communiquer avec vous, y compris le support client';

  @override
  String get info_usage_5 => '• Analyser l\'utilisation de l\'application pour optimiser l\'expérience utilisateur';

  @override
  String get info_usage_6 => '• Prévenir la fraude et assurer la sécurité';

  @override
  String get info_sharing => 'Partage d\'informations';

  @override
  String get info_sharing_1 => 'Nous ne vendons, ne louons ni n\'échangeons vos informations personnelles. Nous ne partageons des informations que dans les cas suivants:';

  @override
  String get info_sharing_2 => '• Avec votre consentement explicite';

  @override
  String get info_sharing_3 => '• Nécessaire pour traiter les transactions et les services';

  @override
  String get info_sharing_4 => '• Pour se conformer aux exigences légales ou aux ordonnances judiciaires';

  @override
  String get info_sharing_5 => '• Pour protéger nos droits, biens ou sécurité';

  @override
  String get info_sharing_6 => '• Avec des fournisseurs de services de confiance (sous accord de confidentialité)';

  @override
  String get data_security => 'Sécurité des données';

  @override
  String get data_security_1 => 'Nous prenons les mesures suivantes pour protéger vos informations:';

  @override
  String get data_security_2 => '• Utiliser le cryptage SSL/TLS pour transmettre les données';

  @override
  String get data_security_3 => '• Stockage sécurisé de votre mot de passe (hachage crypté)';

  @override
  String get data_security_4 => '• Audits de sécurité réguliers et analyse des vulnérabilités';

  @override
  String get data_security_5 => '• Restreindre l\'accès des employés aux informations personnelles';

  @override
  String get data_security_6 => '• Exiger des fournisseurs de services de respecter des normes de sécurité strictes';

  @override
  String get your_rights => 'Vos droits';

  @override
  String get your_rights_1 => 'Vous avez les droits suivants concernant vos informations personnelles:';

  @override
  String get your_rights_2 => '• Droit d\'accès: Voir les informations que nous détenons sur vous';

  @override
  String get your_rights_3 => '• Droit de correction: Mettre à jour ou corriger des informations inexactes';

  @override
  String get your_rights_4 => '• Droit de suppression: Demander la suppression de vos informations personnelles';

  @override
  String get your_rights_5 => '• Droit d\'opposition: S\'opposer à certaines activités de traitement des données';

  @override
  String get your_rights_6 => '• Retrait du consentement: Retirer le consentement précédemment donné';

  @override
  String get your_rights_7 => '• Portabilité des données: Recevoir vos données dans un format structuré';

  @override
  String get cookie_policy => 'Politique sur les cookies';

  @override
  String get cookie_policy_1 => 'Nous utilisons des cookies et technologies similaires pour:';

  @override
  String get cookie_policy_2 => '• Mémoriser vos identifiants de connexion';

  @override
  String get cookie_policy_3 => '• Mémoriser vos préférences';

  @override
  String get cookie_policy_4 => '• Analyser les performances de l\'application';

  @override
  String get cookie_policy_5 => '• Fournir du contenu personnalisé';

  @override
  String get cookie_policy_6 => '• Vous pouvez gérer les préférences de cookies via les paramètres de votre appareil';

  @override
  String get child_privacy => 'Confidentialité des enfants';

  @override
  String get child_privacy_1 => 'Nos services ne sont pas destinés aux enfants de moins de 13 ans.';

  @override
  String get child_privacy_2 => 'Si nous découvrons que nous avons collecté des informations personnelles d\'enfants de moins de 13 ans,';

  @override
  String get child_privacy_3 => 'nous prendrons des mesures pour supprimer ces informations.';

  @override
  String get policy_changes => 'Modifications de la politique';

  @override
  String get policy_changes_1 => 'Nous pouvons mettre à jour cette politique de confidentialité de temps à autre.';

  @override
  String get policy_changes_2 => '• Après les modifications, nous vous en informerons dans l\'application.';

  @override
  String get policy_changes_3 => 'L\'utilisation continue de nos services indique l\'acceptation de la politique mise à jour.';

  @override
  String get policy_changes_4 => 'Nous vous recommandons de consulter régulièrement cette page pour les dernières informations.';

  @override
  String get contact_us_section => 'Contactez-nous';

  @override
  String get contact_us_1 => 'Si vous avez des questions ou des préoccupations concernant cette politique de confidentialité, veuillez nous contacter:';

  @override
  String get contact_us_2 => '• E-mail: support@refundo.com';

  @override
  String get contact_us_3 => '• Commentaires dans l\'application: Paramètres > Aide et commentaires';

  @override
  String get contact_us_4 => '• Nous répondrons dans les 30 jours';

  @override
  String get view_privacy_policy => 'Voir la politique de confidentialité';

  @override
  String get get_help_and_feedback => 'Obtenir de l\'aide et des commentaires';

  @override
  String get not_set => 'Non défini';

  @override
  String get search_help => 'Rechercher des sujets d\'aide...';

  @override
  String get frequently_asked_questions => 'Questions Fréquentes';

  @override
  String get faq1_question => 'Comment scanner une commande?';

  @override
  String get faq1_answer => 'Appuyez sur le bouton scanner sur la page des commandes et pointez votre caméra vers le code QR sur votre reçu.';

  @override
  String get faq2_question => 'Quelles sont les exigences de remboursement?';

  @override
  String get faq2_answer => 'Les commandes doivent avoir au moins 5 mois et un montant de remboursement minimum de 5000 FCFA.';

  @override
  String get faq3_question => 'Combien de temps prend le traitement du remboursement?';

  @override
  String get faq3_answer => 'Les demandes de remboursement sont généralement traitées dans les 3 à 5 jours ouvrables.';

  @override
  String get faq4_question => 'Puis-je suivre le statut de mon remboursement?';

  @override
  String get faq4_answer => 'Oui, vous pouvez suivre le statut de votre remboursement dans la section Remboursements de l\'application.';

  @override
  String get video_tutorials => 'Tutoriels Vidéo';

  @override
  String get tutorial1_title => 'Premiers Pas avec RefundO';

  @override
  String get tutorial1_desc => 'Apprenez les bases du scan des commandes et des demandes de remboursement';

  @override
  String get tutorial2_title => 'Guide des Fonctionnalités Avancées';

  @override
  String get tutorial2_desc => 'Explorez les fonctionnalités avancées comme les remboursements groupés et les statistiques';

  @override
  String get contact_us => 'Contactez-nous';

  @override
  String get email_support => 'Support par E-mail';

  @override
  String get email_support_address => 'support@refundo.com';

  @override
  String get phone_support => 'Support Téléphonique';

  @override
  String get phone_support_number => '+237 XXX XXX XXX';

  @override
  String get whatsapp_support => 'Support WhatsApp';

  @override
  String get whatsapp_available => 'Disponible Lun-Ven 9:00-17:00';

  @override
  String get send_feedback => 'Envoyer des Commentaires';

  @override
  String get feedback_description => 'Nous apprécions vos commentaires! Faites-nous savoir comment nous pouvons améliorer nos services.';

  @override
  String get enter_your_feedback => 'Entrez vos commentaires ici...';

  @override
  String get submit_feedback => 'Soumettre des Commentaires';

  @override
  String get feedback_submitted_successfully => 'Merci! Vos commentaires ont été soumis avec succès.';

  @override
  String get verify_identity => 'Vérifier Votre Identité';

  @override
  String get new_email => 'Nouvel E-mail';

  @override
  String get confirm_new_email => 'Confirmer l\'E-mail';

  @override
  String get enter_old_password => 'Entrez l\'Ancien Mot de Passe';

  @override
  String get please_enter_new_password => 'Veuillez entrer le nouveau mot de passe';

  @override
  String get please_enter_password => 'Veuillez entrer le mot de passe';

  @override
  String get enter_password_to_verify => 'Veuillez entrer votre mot de passe pour vérifier votre identité';

  @override
  String get enter_old_password_tip => 'Entrez votre mot de passe actuel pour confirmer le changement';

  @override
  String get email_format_tip => 'Veuillez entrer une adresse e-mail valide (par exemple, exemple@domaine.com)';

  @override
  String get emails_do_not_match => 'Les adresses e-mail ne correspondent pas';

  @override
  String get tips => 'Conseils';

  @override
  String get retry => 'Réessayer';

  @override
  String get no_orders_yet => 'Aucune commande';

  @override
  String get scan_products_to_add_orders => 'Scannez des produits pour ajouter des commandes';

  @override
  String get scan_now => 'Scanner maintenant';

  @override
  String get no_refunds_yet => 'Aucun remboursement';

  @override
  String get submit_refund_requests_here => 'Soumettez vos demandes de remboursement ici';

  @override
  String get date_range => 'Période';

  @override
  String get sort_by => 'Trier par';

  @override
  String get filter => 'Filtrer';

  @override
  String get apply => 'Appliquer';

  @override
  String get status => 'Statut';

  @override
  String get transaction_failed => 'Transaction Failed';

  @override
  String get transaction_receipt => 'Transaction Receipt';

  @override
  String get few_label => 'Few';

  @override
  String get withdrawn => 'Withdrawn';

  @override
  String get pending_withdrawal => 'Pending Withdrawal';

  @override
  String get click_to_view_full_image => 'Appuyez pour voir l\'image complète';

  @override
  String get image_load_failed => 'Échec du chargement';

  @override
  String get no_orders_yet_detail => 'Scannez le QR code pour ajouter votre première commande';

  @override
  String get no_refunds_yet_detail => 'Vos demandes de remboursement apparaîtront ici';

  @override
  String get no_search_results => 'Aucun résultat trouvé';

  @override
  String no_search_results_detail(Object query) {
    return 'Aucun contenu trouvé correspondant à \"$query\"';
  }

  @override
  String get clear_search => 'Effacer la recherche';

  @override
  String get network_connection_failed => 'Échec de la connexion réseau';

  @override
  String get check_network_settings => 'Veuillez vérifier vos paramètres réseau et réessayer';

  @override
  String get server_error_title => 'Erreur du serveur';

  @override
  String get server_error_detail => 'Serveur temporairement indisponible, veuillez réessayer plus tard';

  @override
  String get no_more_data => 'Pas plus de données';

  @override
  String get total_orders_label => 'Total des commandes';

  @override
  String get orders_count_label => 'commandes';

  @override
  String get total_amount_label => 'Montant total';

  @override
  String get order_statistics_section => 'Statistiques des commandes';

  @override
  String get todays_orders => 'Commandes du jour';

  @override
  String get refund_statistics_section => 'Statistiques de remboursement';

  @override
  String get pending_label => 'En attente';

  @override
  String get completed_label => 'Terminé';

  @override
  String get registration_successful_please_login => 'Inscription réussie ! Veuillez vous connecter avec votre compte';

  @override
  String get registration_failed_please_try_again => 'Inscription échouée, veuillez réessayer';

  @override
  String get check_for_updates => 'Vérifier les mises à jour';

  @override
  String get check_update_subtitle => 'Vérifier si une nouvelle version est disponible';

  @override
  String get new_version_available => 'Nouvelle version disponible';

  @override
  String get current_version => 'Version actuelle';

  @override
  String get download_size => 'Taille du téléchargement';

  @override
  String get update_log => 'Journal des mises à jour';

  @override
  String get no_update_log_available => 'Aucun journal de mise à jour disponible';

  @override
  String get remind_later => 'Me rappeler plus tard';

  @override
  String get update_now => 'Mettre à jour maintenant';

  @override
  String get already_latest_version => 'Dernière version';

  @override
  String get check_update_failed => 'Échec de la vérification';

  @override
  String get check_update_failed_message => 'Impossible de vérifier les mises à jour. Veuillez vérifier votre connexion réseau.';

  @override
  String get downloading_update => 'Téléchargement et installation de la mise à jour...';

  @override
  String get download_failed => 'Échec du téléchargement. Veuillez réessayer.';

  @override
  String get ok => 'OK';
}
