import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("environment")

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationId = "com.transittracker.app.dev"
            resValue(type = "string", name = "app_name", value = "TransitTracker Dev")
        }
        create("prod") {
            dimension = "environment"
            applicationId = "com.transittracker.app"
            resValue(type = "string", name = "app_name", value = "TransitTracker")
        }
    }
}