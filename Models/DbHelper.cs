using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;

namespace Project.Models
{
    public class ProductItem
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Category { get; set; }
        public decimal Price { get; set; }
        public string ImageUrl { get; set; }
        public string Description { get; set; }
        public int StockQuantity { get; set; }
    }

    public static class DbHelper
    {
        public static string GetConnectionString()
        {
            try
            {
                var connSetting = ConfigurationManager.ConnectionStrings["AgriDbConn"];
                if (connSetting != null && !string.IsNullOrEmpty(connSetting.ConnectionString))
                    return connSetting.ConnectionString;
            }
            catch { }

            // Safe absolute project fallback for CLI / IIS
            string projectDir = @"d:\Krutika_24SOECE11036_.NET\Project";
            string fallbackPath = Path.Combine(projectDir, "App_Data", "Database1.mdf");
            return $@"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename={fallbackPath};Integrated Security=True";
        }

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(GetConnectionString());
        }

        /// <summary>
        /// Ensures all necessary application tables exist in SQL Server LocalDB via pure ADO.NET C#
        /// </summary>
        public static void EnsureDatabaseTablesExist()
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();

                    string[] sqlBatches = new string[]
                    {
                        // 1. Register Table
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Register')
                        BEGIN
                            CREATE TABLE [dbo].[Register] (
                                [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [name] VARCHAR(100) NOT NULL,
                                [email] VARCHAR(100) NOT NULL UNIQUE,
                                [password] VARCHAR(100) NOT NULL,
                                [gender] VARCHAR(20) NOT NULL,
                                [contact] NCHAR(15) NOT NULL,
                                [city] VARCHAR(50) NOT NULL,
                                [role] VARCHAR(20) NOT NULL DEFAULT 'User'
                            );
                        END",

                        // 2. Add role column if missing in older schema
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Register' AND COLUMN_NAME = 'role')
                        BEGIN
                            ALTER TABLE [dbo].[Register] ADD [role] VARCHAR(20) NOT NULL DEFAULT 'User';
                        END",

                        // 3. Seed default Administrator and User if not already existing
                        @"IF NOT EXISTS (SELECT 1 FROM [dbo].[Register] WHERE [email] = 'admin@agriconnect.com')
                        BEGIN
                            INSERT INTO [dbo].[Register] ([name], [email], [password], [gender], [contact], [city], [role])
                            VALUES ('Krutika Sheth', 'admin@agriconnect.com', 'admin123', 'Female', '9876543210', 'Ahmedabad', 'Admin');
                        END",

                        @"IF NOT EXISTS (SELECT 1 FROM [dbo].[Register] WHERE [email] = 'user@agriconnect.com')
                        BEGIN
                            INSERT INTO [dbo].[Register] ([name], [email], [password], [gender], [contact], [city], [role])
                            VALUES ('Krutika Sheth', 'user@agriconnect.com', 'user123', 'Female', '9876543211', 'Ahmedabad', 'User');
                        END",

                        // 4. Products Table
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Products')
                        BEGIN
                            CREATE TABLE [dbo].[Products] (
                                [ProductId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [Name] VARCHAR(150) NOT NULL,
                                [Category] VARCHAR(50) NOT NULL,
                                [Price] DECIMAL(18,2) NOT NULL,
                                [ImageUrl] VARCHAR(255) NULL,
                                [Description] VARCHAR(500) NULL,
                                [StockQuantity] INT NOT NULL DEFAULT 100,
                                [IsActive] BIT NOT NULL DEFAULT 1,
                                [CreatedDate] DATETIME DEFAULT GETDATE()
                            );
                        END",

                        @"IF NOT EXISTS (SELECT 1 FROM [dbo].[Products])
                        BEGIN
                            INSERT INTO [dbo].[Products] ([Name],[Category],[Price],[ImageUrl],[Description],[StockQuantity]) VALUES
                            ('Snake Plant','plants',499.00,'image/product-snake-plant.png','Air purifying indoor plant, low maintenance and hardy',50),
                            ('Succulent Plant','plants',349.00,'image/product-succulent.png','Drought tolerant desktop beauty, requires minimal watering',75),
                            ('Organic PottingMix','fertilizers',299.00,'image/product-potting-mix.png','Nutrient rich enriched soil blend for indoor and outdoor plants',120),
                            ('Watering Can','tools',399.00,'image/product-watering-can.png','1.5L ergonomic capacity with precision spout for gentle watering',40),
                            ('Pruning Shears','tools',349.00,'image/product-pruning-shears.png','Sharp high-carbon steel blades for clean cuts and plant health',60),
                            ('Sunflower Seeds','seeds',149.00,'image/sunflower.jfif','High germination non-GMO seeds for bright, cheerful blooms',200),
                            ('Ceramic Planter Pot','pots',279.00,'image/about-plants.PNG','Modern ribbed matte finish 6-inch planter with drainage hole',80),
                            ('Neem Spray Care','care',199.00,'image/tulsi.jfif','100% Organic cold-pressed neem pesticide and fungal defense spray',150),
                            ('Plant Lovers Gift Set','gifts',699.00,'image/about-story.PNG','Curated gardening starter kit with seeds, planter, trowel and guide',30);
                        END",

                        // 5. Cart Table
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Cart')
                        BEGIN
                            CREATE TABLE [dbo].[Cart] (
                                [CartId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [UserEmail] VARCHAR(100) NOT NULL,
                                [ProductName] VARCHAR(150) NOT NULL,
                                [Price] DECIMAL(18,2) NOT NULL,
                                [Quantity] INT NOT NULL DEFAULT 1,
                                [ImageUrl] VARCHAR(255) NULL,
                                [CreatedDate] DATETIME DEFAULT GETDATE()
                            );
                        END",

                        // 6. Wishlist Table
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Wishlist')
                        BEGIN
                            CREATE TABLE [dbo].[Wishlist] (
                                [WishlistId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [UserEmail] VARCHAR(100) NOT NULL,
                                [ProductName] VARCHAR(150) NOT NULL,
                                [Price] DECIMAL(18,2) NOT NULL,
                                [ImageUrl] VARCHAR(255) NULL,
                                [CreatedDate] DATETIME DEFAULT GETDATE()
                            );
                        END",

                        // 7. Orders Table
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Orders')
                        BEGIN
                            CREATE TABLE [dbo].[Orders] (
                                [OrderId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [OrderNumber] VARCHAR(50) NOT NULL,
                                [UserEmail] VARCHAR(100) NOT NULL,
                                [CustomerName] VARCHAR(100) NOT NULL,
                                [ShippingAddress] VARCHAR(255) NOT NULL,
                                [City] VARCHAR(50) NOT NULL,
                                [ContactNumber] VARCHAR(20) NOT NULL,
                                [PaymentMethod] VARCHAR(50) NOT NULL,
                                [TotalAmount] DECIMAL(18,2) NOT NULL,
                                [OrderStatus] VARCHAR(50) NOT NULL DEFAULT 'Placed',
                                [OrderDate] DATETIME DEFAULT GETDATE()
                            );
                        END",

                        // 8. OrderItems Table
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'OrderItems')
                        BEGIN
                            CREATE TABLE [dbo].[OrderItems] (
                                [OrderItemId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [OrderId] INT NOT NULL,
                                [ProductName] VARCHAR(150) NOT NULL,
                                [Price] DECIMAL(18,2) NOT NULL,
                                [Quantity] INT NOT NULL,
                                [SubTotal] DECIMAL(18,2) NOT NULL
                            );
                        END",

                        // 9. UserSettings Table
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'UserSettings')
                        BEGIN
                            CREATE TABLE [dbo].[UserSettings] (
                                [SettingId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [UserEmail] VARCHAR(100) NOT NULL,
                                [FullName] VARCHAR(100) NULL,
                                [ContactNumber] VARCHAR(20) NULL,
                                [ShippingAddress] VARCHAR(255) NULL,
                                [City] VARCHAR(50) NULL,
                                [EmailNotifications] BIT DEFAULT 1,
                                [SmsAlerts] BIT DEFAULT 1,
                                [UpdatedDate] DATETIME DEFAULT GETDATE()
                            );
                        END",

                        // 10. AIDiagnoseHistory Table
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AIDiagnoseHistory')
                        BEGIN
                            CREATE TABLE [dbo].[AIDiagnoseHistory] (
                                [DiagnoseId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [UserEmail] VARCHAR(100) NOT NULL,
                                [PlantName] VARCHAR(100) NOT NULL,
                                [DiseaseName] VARCHAR(150) NOT NULL,
                                [ConfidenceScore] VARCHAR(50) NOT NULL,
                                [TreatmentRecommendation] VARCHAR(MAX) NOT NULL,
                                [ImagePath] VARCHAR(255) NULL,
                                [DiagnoseDate] DATETIME DEFAULT GETDATE()
                            );
                        END",

                        // 11. PlantDiseases Catalog Table (pure DB-stored disease remedies, NOT external AI)
                        @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PlantDiseases')
                        BEGIN
                            CREATE TABLE [dbo].[PlantDiseases] (
                                [DiseaseId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [PlantName] VARCHAR(100) NOT NULL,
                                [DiseaseName] VARCHAR(150) NOT NULL,
                                [Symptoms] VARCHAR(500) NOT NULL,
                                [Treatment] VARCHAR(MAX) NOT NULL,
                                [MedicineName] VARCHAR(150) NOT NULL,
                                [MedicinePrice] DECIMAL(18,2) NOT NULL DEFAULT 199,
                                [ImageUrl] VARCHAR(255) NULL,
                                [CreatedDate] DATETIME DEFAULT GETDATE()
                            );
                        END",

                        @"IF (SELECT COUNT(*) FROM [dbo].[PlantDiseases]) < 30
                        BEGIN
                            DELETE FROM [dbo].[PlantDiseases];
                            INSERT INTO [dbo].[PlantDiseases] ([PlantName], [DiseaseName], [Symptoms], [Treatment], [MedicineName], [MedicinePrice], [ImageUrl]) VALUES
                            ('Tulsi (Holy Basil)', 'Powdery Mildew & Leaf Spot', 'White powdery coating on leaves, black spots and curling', '1. Spray organic cold-pressed neem spray solution every 5-7 days.' + CHAR(10) + '2. Prune heavily affected lower leaves to improve airflow.' + CHAR(10) + '3. Water at the soil base only to keep foliage dry.' + CHAR(10) + '4. Ensure 4-6 hours of warm sunlight daily.', 'Neem Spray Care', 199.00, 'image/tulsi.jfif'),
                            ('Sunflower', 'Alternaria Leaf Blight & Rust', 'Brown necrotic lesions with yellow halos on leaf surface', '1. Apply organic neem spray fungicide weekly.' + CHAR(10) + '2. Maintain proper plant spacing to decrease moisture.' + CHAR(10) + '3. Water early in the morning.' + CHAR(10) + '4. Enrich soil base with organic potting mix.', 'Neem Spray Care', 199.00, 'image/sunflower.jfif'),
                            ('Snake Plant', 'Root Rot & Overwatering Chlorosis', 'Yellowing soft mushy leaves near base, drooping foliage', '1. Stop watering immediately; allow soil to dry completely.' + CHAR(10) + '2. Repot into fresh porous Organic PottingMix with good drainage.' + CHAR(10) + '3. Cut off mushy yellow leaves near the rhizome.' + CHAR(10) + '4. Place in bright indirect sunlight.', 'Organic PottingMix', 299.00, 'image/product-snake-plant.png'),
                            ('Succulent Plant', 'Mealybug Pest & Etiolation', 'White cotton-like pest clusters, stretched pale weak stems', '1. Spray neem oil solution directly on affected stems and leaves.' + CHAR(10) + '2. Place plant on a sunny windowsill for 6+ hours of sunlight.' + CHAR(10) + '3. Water only when soil is completely dry.' + CHAR(10) + '4. Ensure pot has drainage holes.', 'Neem Spray Care', 199.00, 'image/product-succulent.png'),
                            ('Tomato Plant', 'Early Blight (Alternaria solani)', 'Concentric dark target-like rings on older leaves, wilting', '1. Spray Neem Spray Care organic solution on top and underside of leaves.' + CHAR(10) + '2. Prune infected bottom leaves with clean shears.' + CHAR(10) + '3. Mulch soil to avoid fungal spores splashing from soil.', 'Neem Spray Care', 199.00, 'image/tulsi.jfif'),
                            ('Rose Plant', 'Black Spot & Aphids', 'Circular black spots on leaves, yellowing foliage, tiny pests', '1. Treat with Neem Spray Care every week.' + CHAR(10) + '2. Remove infected fallen leaves immediately.' + CHAR(10) + '3. Enrich root soil with Organic PottingMix for healthy growth.', 'Neem Spray Care', 199.00, 'image/about-plants.PNG'),
                            ('Neem Tree', 'Bacterial Blight', 'Yellowing of leaves, brown spots, leaf shedding', '1. Use clean pruning shears to remove affected branches.' + CHAR(10) + '2. Apply neem-based bio-pesticide to control spread.' + CHAR(10) + '3. Provide proper nutrition with organic mix.' + CHAR(10) + '4. Ensure soil is well-drained.', 'Pruning Shears', 349.00, 'image/about-story.PNG'),
                            ('Mango Tree', 'Anthracnose & Powdery Mildew', 'Black spots on leaves and flowers, white powdery fungal growth', '1. Spray organic fungicide before flowering.' + CHAR(10) + '2. Prune dead branches using clean shears.' + CHAR(10) + '3. Avoid overhead watering.' + CHAR(10) + '4. Add organic compost to roots.', 'Pruning Shears', 349.00, 'image/flower.jfif'),
                            ('Banana Plant', 'Panama Disease (Fusarium Wilt)', 'Yellowing of older leaves, wilting, splitting of stem', '1. Remove and destroy infected plants.' + CHAR(10) + '2. Use disease-free potting mix for new plants.' + CHAR(10) + '3. Ensure proper soil drainage.' + CHAR(10) + '4. Apply organic compost.', 'Organic PottingMix', 299.00, 'image/perivinkle.jfif'),
                            ('Cotton Plant', 'Bacterial Blight (Angular Leaf Spot)', 'Water-soaked angular spots on leaves, turning dark brown', '1. Use disease-free seeds.' + CHAR(10) + '2. Spray neem-based solutions early.' + CHAR(10) + '3. Crop rotation with non-host plants.' + CHAR(10) + '4. Remove infected crop debris.', 'Neem Spray Care', 199.00, 'image/images.jfif'),
                            ('Wheat Plant', 'Leaf Rust', 'Small brown or orange pustules on leaf surface', '1. Grow resistant varieties.' + CHAR(10) + '2. Apply organic fungicide spray.' + CHAR(10) + '3. Avoid excessive nitrogen fertilizer.' + CHAR(10) + '4. Ensure proper spacing.', 'Neem Spray Care', 199.00, 'image/money_well.jfif'),
                            ('Rice Plant', 'Blast Disease', 'Diamond-shaped white to gray lesions with brown borders', '1. Use resistant seed varieties.' + CHAR(10) + '2. Avoid excessive nitrogen applications.' + CHAR(10) + '3. Keep fields properly flooded but manageable.' + CHAR(10) + '4. Apply organic treatments.', 'Organic PottingMix', 299.00, 'image/tulsi.jfif'),
                            ('Marigold', 'Botrytis Blight', 'Brown spotting on flowers, gray fuzzy mold', '1. Remove infected flowers using shears.' + CHAR(10) + '2. Improve air circulation around plants.' + CHAR(10) + '3. Keep water off foliage.' + CHAR(10) + '4. Spray organic fungicide.', 'Pruning Shears', 349.00, 'image/sunflower.jfif'),
                            ('Jasmine', 'Cercospora Leaf Spot', 'Reddish-brown spots on leaves, premature defoliation', '1. Remove heavily infected leaves.' + CHAR(10) + '2. Apply neem spray evenly.' + CHAR(10) + '3. Water at base to avoid wet leaves.' + CHAR(10) + '4. Mulch around base.', 'Neem Spray Care', 199.00, 'image/product-snake-plant.png'),
                            ('Aloe Vera', 'Aloe Rust', 'Black or brown circular spots on leaves', '1. Stop overhead watering.' + CHAR(10) + '2. Cut off affected leaves carefully.' + CHAR(10) + '3. Avoid excessive moisture.' + CHAR(10) + '4. Ensure plenty of sunlight.', 'Pruning Shears', 349.00, 'image/product-succulent.png'),
                            ('Money Plant', 'Root Rot', 'Yellowing leaves, stunted growth, mushy black roots', '1. Trim affected roots.' + CHAR(10) + '2. Repot into fresh well-draining mix.' + CHAR(10) + '3. Let soil dry between waterings.' + CHAR(10) + '4. Place in bright indirect light.', 'Organic PottingMix', 299.00, 'image/about-plants.PNG'),
                            ('Mint (Pudina)', 'Mint Rust', 'Small dusty orange, yellow, or brown pustules on leaves', '1. Pluck off infected leaves.' + CHAR(10) + '2. Thin out the mint patch for airflow.' + CHAR(10) + '3. Water roots only.' + CHAR(10) + '4. Use organic neem spray.', 'Neem Spray Care', 199.00, 'image/about-story.PNG'),
                            ('Curry Leaf Plant', 'Scale Insects', 'Hard brown bumps on stems and leaves, yellowing', '1. Prune heavily infested branches.' + CHAR(10) + '2. Spray neem oil solution thoroughly.' + CHAR(10) + '3. Wipe leaves with soft cloth.' + CHAR(10) + '4. Keep plant well fertilized.', 'Pruning Shears', 349.00, 'image/flower.jfif'),
                            ('Lemon Tree', 'Citrus Canker', 'Raised corky lesions on leaves and fruit with yellow halos', '1. Prune affected branches in dry weather.' + CHAR(10) + '2. Apply neem-based protective spray.' + CHAR(10) + '3. Destroy infected fallen leaves.' + CHAR(10) + '4. Avoid overhead irrigation.', 'Neem Spray Care', 199.00, 'image/perivinkle.jfif'),
                            ('Guava Tree', 'Fruit Rot', 'Brown circular spots on fruits, softening and rotting', '1. Remove and destroy rotting fruits.' + CHAR(10) + '2. Spray organic fungicide.' + CHAR(10) + '3. Prune tree for better aeration.' + CHAR(10) + '4. Apply balanced organic compost.', 'Pruning Shears', 349.00, 'image/images.jfif'),
                            ('Papaya Plant', 'Papaya Ring Spot Virus', 'Yellow mottling on leaves, ring spots on fruit', '1. Remove infected plants completely.' + CHAR(10) + '2. Control aphids with neem spray.' + CHAR(10) + '3. Keep area weed-free.' + CHAR(10) + '4. Use disease-free seedlings.', 'Neem Spray Care', 199.00, 'image/money_well.jfif'),
                            ('Chili Plant', 'Chili Leaf Curl', 'Upward curling of leaves, stunted growth, yellowing', '1. Spray neem oil to control whiteflies.' + CHAR(10) + '2. Remove heavily infected plants.' + CHAR(10) + '3. Maintain good soil health with organic mix.' + CHAR(10) + '4. Rotate crops yearly.', 'Organic PottingMix', 299.00, 'image/tulsi.jfif'),
                            ('Coriander (Dhania)', 'Powdery Mildew', 'White powdery growth on leaves and stems', '1. Thin plants to improve airflow.' + CHAR(10) + '2. Apply neem spray at first sign.' + CHAR(10) + '3. Water only at the base.' + CHAR(10) + '4. Provide adequate sunlight.', 'Neem Spray Care', 199.00, 'image/sunflower.jfif'),
                            ('Fenugreek (Methi)', 'Downy Mildew', 'Yellow patches on upper leaf, purplish growth underneath', '1. Use wide spacing for good aeration.' + CHAR(10) + '2. Avoid overhead watering.' + CHAR(10) + '3. Apply organic neem spray.' + CHAR(10) + '4. Remove infected crop debris.', 'Neem Spray Care', 199.00, 'image/product-snake-plant.png'),
                            ('Spinach (Palak)', 'White Rust', 'White blister-like pustules on the underside of leaves', '1. Remove and destroy infected leaves.' + CHAR(10) + '2. Ensure good drainage with organic potting mix.' + CHAR(10) + '3. Rotate crops regularly.' + CHAR(10) + '4. Keep weed-free.', 'Organic PottingMix', 299.00, 'image/product-succulent.png'),
                            ('Drumstick (Moringa)', 'Twig Canker', 'Brown sunken lesions on twigs, dieback', '1. Prune affected twigs below the infection.' + CHAR(10) + '2. Apply protective organic paste on cuts.' + CHAR(10) + '3. Keep plant well-nourished.' + CHAR(10) + '4. Avoid waterlogging.', 'Pruning Shears', 349.00, 'image/about-plants.PNG'),
                            ('Coconut Palm', 'Bud Rot', 'Yellowing of young leaves, rotting of the central bud', '1. Remove infected tissues early.' + CHAR(10) + '2. Apply organic treatments to the crown.' + CHAR(10) + '3. Ensure proper drainage.' + CHAR(10) + '4. Control rhinoceros beetle vectors.', 'Organic PottingMix', 299.00, 'image/about-story.PNG'),
                            ('Basil (Italian)', 'Fusarium Wilt', 'Sudden wilting of leaves, brown streaks on stems', '1. Remove infected plants immediately.' + CHAR(10) + '2. Do not plant basil in the same soil.' + CHAR(10) + '3. Use fresh organic potting mix.' + CHAR(10) + '4. Ensure good drainage.', 'Organic PottingMix', 299.00, 'image/flower.jfif'),
                            ('Lavender', 'Root Rot', 'Yellowing foliage, stunted growth, dark mushy roots', '1. Stop watering immediately.' + CHAR(10) + '2. Repot in fast-draining organic mix.' + CHAR(10) + '3. Trim away dead roots.' + CHAR(10) + '4. Provide full sun exposure.', 'Organic PottingMix', 299.00, 'image/perivinkle.jfif'),
                            ('Hibiscus', 'Aphids & Whiteflies', 'Sticky honeydew on leaves, sooty mold, tiny insects', '1. Spray thoroughly with neem oil.' + CHAR(10) + '2. Prune heavily infested tips.' + CHAR(10) + '3. Wash plant with strong water spray.' + CHAR(10) + '4. Encourage beneficial insects.', 'Neem Spray Care', 199.00, 'image/images.jfif'),
                            ('Bougainvillea', 'Leaf Spot', 'Small brown spots on leaves, defoliation', '1. Rake up fallen leaves.' + CHAR(10) + '2. Avoid overhead irrigation.' + CHAR(10) + '3. Prune to increase air circulation.' + CHAR(10) + '4. Apply organic neem spray.', 'Pruning Shears', 349.00, 'image/money_well.jfif'),
                            ('Pomegranate Tree', 'Cercospora Fruit Spot', 'Irregular black spots on fruits and leaves', '1. Spray organic fungicide early in the season.' + CHAR(10) + '2. Prune tree for better light penetration.' + CHAR(10) + '3. Remove fallen infected leaves.' + CHAR(10) + '4. Apply balanced compost.', 'Pruning Shears', 349.00, 'image/tulsi.jfif'),
                            ('Amla (Indian Gooseberry)', 'Rust Disease', 'Reddish-brown pustules on leaves and fruits', '1. Apply neem-based protective sprays.' + CHAR(10) + '2. Prune dead or diseased branches.' + CHAR(10) + '3. Keep area clean of debris.' + CHAR(10) + '4. Ensure proper fertilization.', 'Neem Spray Care', 199.00, 'image/sunflower.jfif'),
                            ('Ashwagandha', 'Alternaria Blight', 'Brown spots on leaves with concentric rings', '1. Use certified disease-free seeds.' + CHAR(10) + '2. Spray organic neem fungicide.' + CHAR(10) + '3. Provide proper row spacing.' + CHAR(10) + '4. Ensure well-drained soil.', 'Neem Spray Care', 199.00, 'image/product-snake-plant.png'),
                            ('Brahmi', 'Leaf Webworm', 'Webbing on leaves, caterpillar feeding damage', '1. Manually remove webbed leaves.' + CHAR(10) + '2. Apply neem oil spray.' + CHAR(10) + '3. Maintain clean surroundings.' + CHAR(10) + '4. Harvest regularly.', 'Neem Spray Care', 199.00, 'image/product-succulent.png');
                        END"
                    };

                    foreach (var batch in sqlBatches)
                    {
                        using (var cmd = new SqlCommand(batch, con))
                        {
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Database setup error: " + ex.Message);
            }
        }

        public static string GetCurrentUserEmail(HttpContext context)
        {
            if (context != null && context.Session != null && context.Session["UserEmail"] != null)
            {
                string email = context.Session["UserEmail"].ToString().Trim();
                if (!string.IsNullOrEmpty(email))
                    return email;
            }

            // Ensure guest user session is pinned and persistent
            if (context != null && context.Session != null)
            {
                if (context.Session["GuestEmailId"] == null)
                {
                    // Check cookie first
                    if (context.Request != null && context.Request.Cookies["AgriGuestId"] != null)
                    {
                        string cVal = context.Request.Cookies["AgriGuestId"].Value;
                        if (!string.IsNullOrEmpty(cVal))
                            context.Session["GuestEmailId"] = cVal;
                    }

                    if (context.Session["GuestEmailId"] == null)
                    {
                        string sessId = !string.IsNullOrEmpty(context.Session.SessionID)
                            ? context.Session.SessionID.Substring(0, Math.Min(8, context.Session.SessionID.Length))
                            : Guid.NewGuid().ToString("N").Substring(0, 8);

                        string gId = "guest_" + sessId;
                        context.Session["GuestEmailId"] = gId;

                        try
                        {
                            var cookie = new HttpCookie("AgriGuestId", gId)
                            {
                                Expires = DateTime.Now.AddDays(30),
                                HttpOnly = true
                            };
                            context.Response.Cookies.Add(cookie);
                        }
                        catch { }
                    }
                }

                return context.Session["GuestEmailId"].ToString() + "@agriculture.com";
            }

            return "guest@agriculture.com";
        }

        public static int GetCartCount(string userEmail)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT ISNULL(SUM(Quantity), 0) FROM Cart WHERE UserEmail = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch { return 0; }
        }

        public static int GetWishlistCount(string userEmail)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Wishlist WHERE UserEmail = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch { return 0; }
        }

        public static bool AddToCart(string userEmail, string productName, decimal price, int quantity, string imageUrl)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    // Check if item already exists in cart for this user
                    using (var checkCmd = new SqlCommand("SELECT CartId, Quantity FROM Cart WHERE UserEmail = @Email AND ProductName = @Product", con))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", userEmail);
                        checkCmd.Parameters.AddWithValue("@Product", productName);
                        using (var reader = checkCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                int cartId = reader.GetInt32(0);
                                int existingQty = reader.GetInt32(1);
                                reader.Close();

                                using (var updateCmd = new SqlCommand("UPDATE Cart SET Quantity = @Qty WHERE CartId = @CartId", con))
                                {
                                    updateCmd.Parameters.AddWithValue("@Qty", existingQty + quantity);
                                    updateCmd.Parameters.AddWithValue("@CartId", cartId);
                                    updateCmd.ExecuteNonQuery();
                                    return true;
                                }
                            }
                        }
                    }

                    // Not found — insert new
                    using (var insertCmd = new SqlCommand("INSERT INTO Cart (UserEmail, ProductName, Price, Quantity, ImageUrl, CreatedDate) VALUES (@Email, @Product, @Price, @Qty, @Img, GETDATE())", con))
                    {
                        insertCmd.Parameters.AddWithValue("@Email", userEmail);
                        insertCmd.Parameters.AddWithValue("@Product", productName);
                        insertCmd.Parameters.AddWithValue("@Price", price);
                        insertCmd.Parameters.AddWithValue("@Qty", quantity);
                        insertCmd.Parameters.AddWithValue("@Img", (object)imageUrl ?? DBNull.Value);
                        insertCmd.ExecuteNonQuery();
                        return true;
                    }
                }
            }
            catch { return false; }
        }

        public static bool AddToWishlist(string userEmail, string productName, decimal price, string imageUrl)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    // Check if already in wishlist
                    using (var checkCmd = new SqlCommand("SELECT COUNT(*) FROM Wishlist WHERE UserEmail = @Email AND ProductName = @Product", con))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", userEmail);
                        checkCmd.Parameters.AddWithValue("@Product", productName);
                        int exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (exists > 0) return true; // already added
                    }

                    using (var insertCmd = new SqlCommand("INSERT INTO Wishlist (UserEmail, ProductName, Price, ImageUrl, CreatedDate) VALUES (@Email, @Product, @Price, @Img, GETDATE())", con))
                    {
                        insertCmd.Parameters.AddWithValue("@Email", userEmail);
                        insertCmd.Parameters.AddWithValue("@Product", productName);
                        insertCmd.Parameters.AddWithValue("@Price", price);
                        insertCmd.Parameters.AddWithValue("@Img", (object)imageUrl ?? DBNull.Value);
                        insertCmd.ExecuteNonQuery();
                        return true;
                    }
                }
            }
            catch { return false; }
        }

        /// <summary>
        /// Fetches ALL active products from the SQL Server Products table (real DB data)
        /// </summary>
        public static List<ProductItem> GetProductsFromDB(string category = "all")
        {
            var list = new List<ProductItem>();
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    string sql;
                    SqlCommand cmd;

                    if (string.IsNullOrEmpty(category) || category == "all")
                    {
                        sql = "SELECT ProductId, Name, Category, Price, ImageUrl, Description, StockQuantity FROM Products WHERE IsActive = 1 ORDER BY ProductId ASC";
                        cmd = new SqlCommand(sql, con);
                    }
                    else
                    {
                        sql = "SELECT ProductId, Name, Category, Price, ImageUrl, Description, StockQuantity FROM Products WHERE IsActive = 1 AND Category = @Cat ORDER BY ProductId ASC";
                        cmd = new SqlCommand(sql, con);
                        cmd.Parameters.AddWithValue("@Cat", category);
                    }

                    using (cmd)
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                list.Add(new ProductItem
                                {
                                    Id            = Convert.ToInt32(reader["ProductId"]),
                                    Name          = reader["Name"].ToString(),
                                    Category      = reader["Category"].ToString(),
                                    Price         = Convert.ToDecimal(reader["Price"]),
                                    ImageUrl      = reader["ImageUrl"] != DBNull.Value ? reader["ImageUrl"].ToString() : "image/product-snake-plant.png",
                                    Description   = reader["Description"] != DBNull.Value ? reader["Description"].ToString() : "",
                                    StockQuantity = Convert.ToInt32(reader["StockQuantity"])
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetProductsFromDB error: " + ex.Message);
            }
            return list;
        }

        /// <summary>
        /// Gets a single product from the Products table by its ID
        /// </summary>
        public static ProductItem GetProductById(int productId)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT ProductId, Name, Category, Price, ImageUrl, Description, StockQuantity FROM Products WHERE ProductId = @Id AND IsActive = 1", con))
                    {
                        cmd.Parameters.AddWithValue("@Id", productId);
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                return new ProductItem
                                {
                                    Id            = Convert.ToInt32(reader["ProductId"]),
                                    Name          = reader["Name"].ToString(),
                                    Category      = reader["Category"].ToString(),
                                    Price         = Convert.ToDecimal(reader["Price"]),
                                    ImageUrl      = reader["ImageUrl"] != DBNull.Value ? reader["ImageUrl"].ToString() : "image/product-snake-plant.png",
                                    Description   = reader["Description"] != DBNull.Value ? reader["Description"].ToString() : "",
                                    StockQuantity = Convert.ToInt32(reader["StockQuantity"])
                                };
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetProductById error: " + ex.Message);
            }
            return null;
        }

        /// <summary>
        /// Fetches all products from DB as DataTable (for admin grids)
        /// </summary>
        public static DataTable GetAllProductsDataTable()
        {
            DataTable dt = new DataTable();
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT ProductId, Name, Category, Price, ImageUrl, Description, StockQuantity, IsActive, CreatedDate FROM Products ORDER BY ProductId DESC", con))
                    {
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetAllProductsDataTable error: " + ex.Message);
            }
            return dt;
        }

        /// <summary>
        /// Inserts an AI Plant Diagnosis result into AIDiagnoseHistory in SQL Server LocalDB
        /// </summary>
        public static int SaveAIDiagnosis(string userEmail, string plantName, string diseaseName, string confidence, string treatment, string imagePath)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    string insertSql = @"INSERT INTO AIDiagnoseHistory 
                                        (UserEmail, PlantName, DiseaseName, ConfidenceScore, TreatmentRecommendation, ImagePath, DiagnoseDate) 
                                        VALUES (@Email, @Plant, @Disease, @Score, @Treatment, @Img, GETDATE());
                                        SELECT SCOPE_IDENTITY();";
                    using (var cmd = new SqlCommand(insertSql, con))
                    {
                        cmd.Parameters.AddWithValue("@Email",     userEmail);
                        cmd.Parameters.AddWithValue("@Plant",     plantName);
                        cmd.Parameters.AddWithValue("@Disease",   diseaseName);
                        cmd.Parameters.AddWithValue("@Score",     confidence);
                        cmd.Parameters.AddWithValue("@Treatment", treatment);
                        cmd.Parameters.AddWithValue("@Img",       (object)imagePath ?? DBNull.Value);
                        object result = cmd.ExecuteScalar();
                        return result != null ? Convert.ToInt32(result) : 0;
                    }
                }
            }
            catch { return 0; }
        }

        /// <summary>
        /// Fetches all AI diagnoses for a user from SQL Server LocalDB
        /// </summary>
        public static DataTable GetAIDiagnoseHistory(string userEmail)
        {
            DataTable dt = new DataTable();
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    string sql = @"SELECT DiagnoseId, UserEmail, PlantName, DiseaseName, ConfidenceScore, 
                                          TreatmentRecommendation, ImagePath, DiagnoseDate 
                                   FROM AIDiagnoseHistory 
                                   WHERE UserEmail = @Email 
                                   ORDER BY DiagnoseId DESC";
                    using (var cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }
            }
            catch { }
            return dt;
        }

        /// <summary>
        /// Deletes an AI diagnosis history entry from SQL Server LocalDB
        /// </summary>
        public static bool DeleteAIDiagnosis(int diagnoseId, string userEmail)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("DELETE FROM AIDiagnoseHistory WHERE DiagnoseId = @Id AND UserEmail = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Id",    diagnoseId);
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch { return false; }
        }

        /// <summary>
        /// Gets all manually added plant diseases from the database
        /// </summary>
        public static DataTable GetPlantDiseases()
        {
            DataTable dt = new DataTable();
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    string sql = "SELECT DiseaseId, PlantName, DiseaseName, Symptoms, Treatment, MedicineName, MedicinePrice, ImageUrl, CreatedDate FROM PlantDiseases ORDER BY DiseaseId DESC";
                    using (var cmd = new SqlCommand(sql, con))
                    {
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetPlantDiseases error: " + ex.Message);
            }
            return dt;
        }

        /// <summary>
        /// Adds a new plant disease manually into the database table
        /// </summary>
        public static int AddPlantDisease(string plantName, string diseaseName, string symptoms, string treatment, string medicineName, decimal medicinePrice, string imageUrl)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    string sql = @"INSERT INTO PlantDiseases (PlantName, DiseaseName, Symptoms, Treatment, MedicineName, MedicinePrice, ImageUrl, CreatedDate)
                                   VALUES (@PlantName, @DiseaseName, @Symptoms, @Treatment, @MedicineName, @MedicinePrice, @ImageUrl, GETDATE());
                                   SELECT SCOPE_IDENTITY();";
                    using (var cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@PlantName",    plantName);
                        cmd.Parameters.AddWithValue("@DiseaseName",  diseaseName);
                        cmd.Parameters.AddWithValue("@Symptoms",     symptoms);
                        cmd.Parameters.AddWithValue("@Treatment",    treatment);
                        cmd.Parameters.AddWithValue("@MedicineName", medicineName);
                        cmd.Parameters.AddWithValue("@MedicinePrice",medicinePrice);
                        cmd.Parameters.AddWithValue("@ImageUrl",     (object)imageUrl ?? "image/tulsi.jfif");
                        object res = cmd.ExecuteScalar();
                        return res != null ? Convert.ToInt32(res) : 0;
                    }
                }
            }
            catch { return 0; }
        }

        /// <summary>
        /// Deletes a plant disease from the database
        /// </summary>
        public static bool DeletePlantDisease(int diseaseId)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("DELETE FROM PlantDiseases WHERE DiseaseId = @Id", con))
                    {
                        cmd.Parameters.AddWithValue("@Id", diseaseId);
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch { return false; }
        }

        /// <summary>
        /// Migrates cart and wishlist from guest session to authenticated user account upon login
        /// </summary>
        public static void MigrateGuestItems(string guestEmail, string userEmail)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("UPDATE Cart SET UserEmail = @UserEmail WHERE UserEmail = @GuestEmail", con))
                    {
                        cmd.Parameters.AddWithValue("@UserEmail",  userEmail);
                        cmd.Parameters.AddWithValue("@GuestEmail", guestEmail);
                        cmd.ExecuteNonQuery();
                    }
                    using (var cmd = new SqlCommand("UPDATE Wishlist SET UserEmail = @UserEmail WHERE UserEmail = @GuestEmail", con))
                    {
                        cmd.Parameters.AddWithValue("@UserEmail",  userEmail);
                        cmd.Parameters.AddWithValue("@GuestEmail", guestEmail);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch { }
        }

        /// <summary>
        /// Gets dashboard statistics from the real database for the admin/dashboard page
        /// </summary>
        public static Dictionary<string, int> GetDashboardStats()
        {
            var stats = new Dictionary<string, int>
            {
                { "TotalUsers", 0 },
                { "TotalProducts", 0 },
                { "TotalOrders", 0 },
                { "TotalDiseaseRecords", 0 }
            };

            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    string sql = @"
                        SELECT (SELECT COUNT(*) FROM Register) AS TotalUsers,
                               (SELECT COUNT(*) FROM Products WHERE IsActive = 1) AS TotalProducts,
                               (SELECT COUNT(*) FROM Orders) AS TotalOrders,
                               (SELECT COUNT(*) FROM PlantDiseases) AS TotalDiseaseRecords";
                    using (var cmd = new SqlCommand(sql, con))
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                stats["TotalUsers"]          = Convert.ToInt32(reader["TotalUsers"]);
                                stats["TotalProducts"]       = Convert.ToInt32(reader["TotalProducts"]);
                                stats["TotalOrders"]         = Convert.ToInt32(reader["TotalOrders"]);
                                stats["TotalDiseaseRecords"] = Convert.ToInt32(reader["TotalDiseaseRecords"]);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetDashboardStats error: " + ex.Message);
            }
            return stats;
        }

        /// <summary>
        /// Gets all users and admins for AdminManagement
        /// </summary>
        public static DataTable GetAllUsersDataTable()
        {
            DataTable dt = new DataTable();
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    string sql = "SELECT Id, name, email, gender, contact, city, role FROM Register ORDER BY Id DESC";
                    using (var cmd = new SqlCommand(sql, con))
                    {
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetAllUsersDataTable error: " + ex.Message);
            }
            return dt;
        }

        /// <summary>
        /// Adds a new administrator or user to the database
        /// </summary>
        public static bool AddAdminUser(string name, string email, string password, string contact, string city, string role)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var chk = new SqlCommand("SELECT COUNT(*) FROM Register WHERE email = @Email", con))
                    {
                        chk.Parameters.AddWithValue("@Email", email);
                        int count = Convert.ToInt32(chk.ExecuteScalar());
                        if (count > 0) return false;
                    }

                    string sql = "INSERT INTO Register (name, email, password, gender, contact, city, role) VALUES (@Name, @Email, @Password, 'Other', @Contact, @City, @Role)";
                    using (var cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@Name", name);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@Contact", contact);
                        cmd.Parameters.AddWithValue("@City", city);
                        cmd.Parameters.AddWithValue("@Role", role);
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch { return false; }
        }

        /// <summary>
        /// Updates the role of a user in the Register table
        /// </summary>
        public static bool UpdateUserRole(int userId, string newRole)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("UPDATE Register SET role = @Role WHERE Id = @Id", con))
                    {
                        cmd.Parameters.AddWithValue("@Role", newRole);
                        cmd.Parameters.AddWithValue("@Id", userId);
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch { return false; }
        }

        /// <summary>
        /// Deletes a user by ID from the Register table
        /// </summary>
        public static bool DeleteUser(int userId)
        {
            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("DELETE FROM Register WHERE Id = @Id", con))
                    {
                        cmd.Parameters.AddWithValue("@Id", userId);
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch { return false; }
        }

        /// <summary>
        /// Gets detailed reports analytics from the database
        /// </summary>
        public static Dictionary<string, object> GetReportsAnalytics()
        {
            var reports = new Dictionary<string, object>
            {
                { "TotalRevenue", 0m },
                { "TotalOrders", 0 },
                { "TotalUsers", 0 },
                { "TotalProducts", 0 },
                { "PlacedOrders", 0 },
                { "ConfirmedOrders", 0 },
                { "DeliveredOrders", 0 }
            };

            try
            {
                using (var con = GetConnection())
                {
                    con.Open();
                    string sql = @"
                        SELECT 
                            ISNULL(SUM(TotalAmount), 0) AS TotalRevenue,
                            COUNT(*) AS TotalOrders,
                            ISNULL(SUM(CASE WHEN OrderStatus = 'Placed' THEN 1 ELSE 0 END), 0) AS PlacedOrders,
                            ISNULL(SUM(CASE WHEN OrderStatus = 'Confirmed' THEN 1 ELSE 0 END), 0) AS ConfirmedOrders,
                            ISNULL(SUM(CASE WHEN OrderStatus = 'Delivered' THEN 1 ELSE 0 END), 0) AS DeliveredOrders
                        FROM Orders;
                        SELECT COUNT(*) FROM Register;
                        SELECT COUNT(*) FROM Products WHERE IsActive = 1;";

                    using (var cmd = new SqlCommand(sql, con))
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                reports["TotalRevenue"]    = Convert.ToDecimal(reader["TotalRevenue"]);
                                reports["TotalOrders"]     = Convert.ToInt32(reader["TotalOrders"]);
                                reports["PlacedOrders"]    = Convert.ToInt32(reader["PlacedOrders"]);
                                reports["ConfirmedOrders"] = Convert.ToInt32(reader["ConfirmedOrders"]);
                                reports["DeliveredOrders"] = Convert.ToInt32(reader["DeliveredOrders"]);
                            }
                            if (reader.NextResult() && reader.Read())
                            {
                                reports["TotalUsers"] = Convert.ToInt32(reader[0]);
                            }
                            if (reader.NextResult() && reader.Read())
                            {
                                reports["TotalProducts"] = Convert.ToInt32(reader[0]);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetReportsAnalytics error: " + ex.Message);
            }

            return reports;
        }
    }
}
