import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UIApplication.shared.statusBarStyle = .lightContent
        window?.rootViewController = SignInVC()
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Envoyé lorsque l'application est sur le point de passer de l'état actif à l'état inactif. Cela peut se produire pour certains types d'interruptions temporaires (comme un appel téléphonique ou un SMS entrant) ou lorsque l'utilisateur quitte l'application et que celle-ci commence la transition vers l'état d'arrière-plan.
        // Utilisez cette méthode pour mettre en pause les tâches en cours, désactiver les minuteries et invalider les rappels de rendu graphique. Les jeux doivent utiliser cette méthode pour mettre le jeu en pause.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Utilisez cette méthode pour libérer les ressources partagées, enregistrer les données utilisateur, invalider les minuteries et stocker suffisamment d'informations sur l'état de l'application pour restaurer votre application à son état actuel en cas de terminaison ultérieure.
        // Si votre application prend en charge l'exécution en arrière-plan, cette méthode est appelée à la place de applicationWillTerminate: lorsque l'utilisateur quitte.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Appelé dans le cadre de la transition de l'arrière-plan à l'état actif; ici, vous pouvez annuler de nombreuses modifications effectuées en entrant dans l'arrière-plan.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Redémarrez toutes les tâches qui étaient en pause (ou qui n'avaient pas encore commencé) lorsque l'application était inactive. Si l'application était précédemment en arrière-plan, actualisez éventuellement l'interface utilisateur.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Appelé lorsque l'application est sur le point de se terminer. Enregistrez les données si nécessaire. Voir aussi applicationDidEnterBackground:.
        // Enregistre les modifications dans le contexte de l'objet géré de l'application avant la terminaison de celle-ci.
        self.saveContext()
    }

    // MARK: - Pile de Core Data

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         Le conteneur persistant pour l'application. Cette implémentation
         crée et renvoie un conteneur, après avoir chargé le magasin pour l'application dans celui-ci. Cette propriété est optionnelle car il existe des conditions d'erreur légitimes qui pourraient entraîner l'échec de la création du magasin.
        */
        let container = NSPersistentContainer(name: "Storyline")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Remplacez cette implémentation par du code pour gérer l'erreur de manière appropriée.
                // fatalError() provoque la génération d'un journal de crash et la terminaison de l'application. Vous ne devez pas utiliser cette fonction dans une application en production, bien qu'elle puisse être utile pendant le développement.
                 
                /*
                 Les raisons typiques d'une erreur ici incluent :
                 * Le répertoire parent n'existe pas, ne peut pas être créé ou interdit l'écriture.
                 * Le magasin persistant n'est pas accessible, en raison des permissions ou de la protection des données lorsque l'appareil est verrouillé.
                 * L'appareil est à court d'espace.
                 * Le magasin n'a pas pu être migré vers la version actuelle du modèle.
                 Vérifiez le message d'erreur pour déterminer quel était le problème réel.
                 */
                fatalError("Erreur non résolue \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Support de sauvegarde de Core Data

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Remplacez cette implémentation par du code pour gérer l'erreur de manière appropriée.
                // fatalError() provoque la génération d'un journal de crash et la terminaison de l'application. Vous ne devez pas utiliser cette fonction dans une application en production, bien qu'elle puisse être utile pendant le développement.
                let nserror = error as NSError
                fatalError("Erreur non résolue \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
