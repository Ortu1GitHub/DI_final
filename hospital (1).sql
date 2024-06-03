-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-06-2024 a las 21:40:32
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `hospital`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `citas`
--

CREATE TABLE `citas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `fecha` datetime NOT NULL,
  `medico_id` char(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `enfermero_id` bigint(20) UNSIGNED DEFAULT NULL,
  `paciente_id` char(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `citas`
--

INSERT INTO `citas` (`id`, `fecha`, `medico_id`, `enfermero_id`, `paciente_id`, `created_at`, `updated_at`) VALUES
(70, '2024-06-02 14:03:00', '29', 12, '13', '2024-06-02 18:03:45', '2024-06-02 19:21:57'),
(72, '2024-06-09 15:10:00', '29', 3, '22', '2024-06-02 19:10:49', '2024-06-02 19:35:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `enfermeros`
--

CREATE TABLE `enfermeros` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `numero_colegiado` char(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dni` char(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido1` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido2` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` char(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sexo` enum('hombre','mujer') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `horario_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `enfermeros`
--

INSERT INTO `enfermeros` (`id`, `numero_colegiado`, `dni`, `nombre`, `apellido1`, `apellido2`, `telefono`, `sexo`, `horario_id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, '925140758', '69313501B', 'Josefa', 'Castañeda', 'Lugo', '+34 920-947924', 'hombre', 1, 95441, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(2, '89855707', '78666459L', 'Ángela', 'Sánchez', 'Castillo', '+34 906069563', 'mujer', 1, 91136, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(3, '859718746', '55527220E', 'Valeria', 'Mojica', 'Santamaría', '923723865', 'mujer', 1, 25821, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(4, '4438905', '87807182J', 'Silvia', 'Ruelas', 'Solano', '997-345625', 'mujer', 3, 60368, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(5, '63195204', '40187594Q', 'Biel', 'Zúñiga', 'Villalobos', '+34 929 021811', 'hombre', 4, 14996, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(6, '224258945', '23873898J', 'Encarnación', 'Castellano', 'Mercado', '+34 978 70 9151', 'mujer', 1, 37036, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(7, '437889785', '93554060L', 'Carlos', 'Duran', 'Escobar', '990 626054', 'hombre', 1, 23517, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(8, '289459686', '72330465L', 'David', 'Urías', 'Montenegro', '+34 999-16-3136', 'hombre', 2, 77891, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(9, '125405447', '31384596S', 'Diego', 'Patiño', 'Díez', '+34 968-328232', 'mujer', 4, 73841, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(10, '833335254', '96962020T', 'Helena', 'Delatorre', 'Navas', '+34 923 59 0731', 'mujer', 2, 44239, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(11, '727827925', '04585136V', 'Diana', 'Rosado', 'Alcántar', '966 317225', 'mujer', 4, 38125, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(12, '788869968', '29608880Z', 'Nahia', 'Vera', 'Guardado', '+34 928 94 2955', 'hombre', 1, 87852, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(13, '405464298', '90144583Q', 'Pedro', 'Segura', 'Calero', '+34 967 69 4434', 'mujer', 2, 61874, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(14, '810713387', '40655919S', 'Nora', 'Maya', 'Rodríguez', '+34 977 34 6018', 'hombre', 1, 90049, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(15, '12770280', '64678243N', 'Miguel Ángel', 'Villalpando', 'Benavides', '+34 922-963648', 'hombre', 1, 87264, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(16, '819720780', '51310586R', 'Ana María', 'Esparza', 'Andreu', '908-37-9627', 'hombre', 1, 23335, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(17, '818310468', '07890788V', 'María Ángeles', 'Gurule', 'Mejía', '+34 935-055373', 'hombre', 2, 57142, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(18, '728102957', '08078940Y', 'Ignacio', 'Manzano', 'Gracia', '+34 946-30-6926', 'hombre', 4, 58651, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(19, '725202265', '11741961R', 'Raúl', 'Valdés', 'Adame', '910-191925', 'hombre', 3, 48072, '2021-01-12 10:31:33', '2021-01-12 10:31:33'),
(20, '596264644', '97469238E', 'Alonso', 'Mateos', 'Benito', '900 290135', 'hombre', 3, 73898, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(21, '441427498', '37451438D', 'Cristina', 'Urbina', 'Madera', '917555675', 'hombre', 4, 39610, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(22, '896648536', '63431198G', 'Samuel', 'Andreu', 'Sáenz', '+34 987-13-1855', 'mujer', 2, 2374, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(23, '773065817', '07403204X', 'Eva', 'De la Fuente', 'Briseño', '+34 956 825811', 'hombre', 1, 2794, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(24, '2819157', '76423390W', 'Yolanda', 'Valdivia', 'Lozano', '+34 922 872462', 'hombre', 3, 53957, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(25, '447370071', '78430730V', 'Lara', 'Apodaca', 'Estrada', '+34 990 041121', 'mujer', 1, 38349, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(26, '571859981', '01596668P', 'Rayan', 'Carrión', 'Ledesma', '941-389544', 'hombre', 1, 8754, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(27, '72129224', '48302482K', 'Gabriel', 'Camarillo', 'Toro', '963 67 9305', 'mujer', 2, 20828, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(28, '387227773', '40897121Q', 'Esther', 'Chacón', 'Gaitán', '944 10 9580', 'mujer', 3, 38773, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(29, '996582532', '25650781P', 'José', 'Valdés', 'Morales', '+34 910-39-9805', 'mujer', 2, 84658, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(30, '653226922', '62325801X', 'Ian', 'Ojeda', 'Borrego', '+34 965 01 6807', 'hombre', 4, 59883, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(31, '112561622', '58735061F', 'Arnau', 'Rojas', 'Cintrón', '+34 901-97-4894', 'hombre', 4, 3344, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(32, '862241504', '57807078M', 'Carmen', 'Barreto', 'Bañuelos', '+34 911 168694', 'hombre', 3, 92214, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(33, '236891736', '24581183W', 'Julia', 'Gallego', 'Altamirano', '940631025', 'hombre', 3, 86678, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(34, '328166155', '55459897C', 'Naiara', 'Frías', 'Monroy', '994606331', 'mujer', 4, 76922, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(35, '944121997', '33359753R', 'Clara', 'Guerrero', 'Zambrano', '957-564068', 'hombre', 4, 99280, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(36, '23075255', '20361376M', 'Ariadna', 'Laboy', 'Rodríguez', '901 28 9866', 'mujer', 3, 97334, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(37, '279444964', '49572435Y', 'Andrea', 'Girón', 'Puga', '958-761090', 'mujer', 3, 51180, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(38, '461697839', '70400959Y', 'Javier', 'Hurtado', 'Soliz', '910-600519', 'hombre', 1, 15537, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(39, '923164843', '19131238E', 'Valentina', 'Lorente', 'Cornejo', '+34 927 610582', 'hombre', 1, 58177, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(40, '176629921', '37994870C', 'José Antonio', 'Cazares', 'Reyes', '+34 900 062773', 'mujer', 2, 58972, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(41, '289873916', '72021051R', 'Isabel', 'Arribas', 'Meza', '+34 908 36 3608', 'mujer', 2, 23776, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(42, '417722892', '78496863W', 'Pol', 'Vélez', 'Ramos', '+34 920-21-8119', 'mujer', 2, 46669, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(43, '857493802', '99669533E', 'Nil', 'Sauceda', 'Tovar', '912-73-5098', 'mujer', 3, 36351, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(44, '21507891', '59785326T', 'Yolanda', 'Carranza', 'Macías', '+34 938-49-2036', 'hombre', 1, 95076, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(45, '847903909', '89362209X', 'Jimena', 'Loya', 'Merino', '+34 962-01-0199', 'mujer', 3, 15667, '2021-01-12 10:31:34', '2021-01-12 10:31:34'),
(46, '542140998', '02183010B', 'Marco', 'Peña', 'Ibarra', '911 971728', 'hombre', 4, 39623, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(47, '270986588', '65150035M', 'Sergio', 'Garay', 'Márquez', '+34 938 647862', 'hombre', 3, 51509, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(48, '51176443', '97958333E', 'Leire', 'Navas', 'Espinoza', '+34 958-82-2734', 'hombre', 2, 71349, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(49, '164167408', '32425869D', 'Lara', 'Dueñas', 'Gallegos', '+34 985 064954', 'hombre', 2, 21563, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(50, '577872519', '29344226K', 'Alma', 'Reyes', 'Rodarte', '+34 977-087304', 'mujer', 1, 84369, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(51, '569322479', '07522954E', 'Daniel', 'Olivares', 'Iglesias', '930551956', 'hombre', 1, 68721, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(52, '639699493', '44555264D', 'Alex', 'Atencio', 'Melgar', '+34 931 403332', 'mujer', 2, 44439, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(53, '119937512', '73259657B', 'Mar', 'Esquibel', 'Fierro', '+34 963-44-6951', 'hombre', 1, 24545, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(54, '219306120', '94798747S', 'Berta', 'Armendáriz', 'Navarrete', '921 39 0325', 'hombre', 3, 43293, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(55, '629324029', '49893327W', 'Erik', 'Leal', 'Araña', '+34 906-009607', 'mujer', 3, 49131, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(56, '12199711', '78903229G', 'Carolina', 'Salazar', 'Godínez', '974 785118', 'mujer', 4, 99363, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(57, '44325424', '58015510B', 'Álvaro', 'Quintero', 'Betancourt', '+34 948 052123', 'mujer', 3, 40582, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(58, '696768832', '49792792T', 'Lucas', 'Leyva', 'Angulo', '907-49-8160', 'hombre', 4, 8930, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(59, '778652438', '05331482J', 'Noa', 'Alonso', 'Benavídez', '947 767779', 'hombre', 3, 65629, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(60, '124071375', '78042214V', 'Gerard', 'Barraza', 'Zambrano', '901-22-6010', 'hombre', 1, 61603, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(61, '652016049', '14270758V', 'Inés', 'Villanueva', 'Covarrubias', '+34 929-433620', 'mujer', 4, 91002, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(62, '935238893', '89074951E', 'Víctor', 'Puga', 'Delgadillo', '976-75-4185', 'mujer', 3, 98258, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(63, '278719036', '54707097X', 'Sofía', 'Rueda', 'Rosales', '909-422426', 'mujer', 3, 17856, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(64, '875675735', '63826097Q', 'Juan José', 'Cabrera', 'Almaráz', '940355220', 'mujer', 2, 59175, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(65, '356154272', '70893553D', 'Ana Isabel', 'Pons', 'Sánchez', '+34 967 603112', 'mujer', 4, 93415, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(66, '6116229', '14000499P', 'Elena', 'Rosas', 'Carreón', '+34 923563629', 'mujer', 1, 15956, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(67, '324268920', '48999876D', 'Pedro', 'Maldonado', 'Hernándes', '975-16-2258', 'hombre', 2, 65407, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(68, '375458099', '25900867S', 'Helena', 'Murillo', 'Mercado', '+34 936-71-4703', 'mujer', 3, 94440, '2021-01-12 10:31:35', '2021-01-12 10:31:35'),
(69, '845344905', '05527734Y', 'Unai', 'Escobar', 'Esparza', '+34 905-744482', 'mujer', 1, 78081, '2021-01-12 10:31:36', '2021-01-12 10:31:36'),
(70, '569624957', '70476511A', 'Fátima', 'Hinojosa', 'Santillán', '979-319713', 'mujer', 4, 5193, '2021-01-12 10:31:36', '2021-01-12 10:31:36'),
(71, '798375827', '56031822G', 'Patricia', 'Piña', 'Carreón', '999 28 6919', 'mujer', 4, 2489, '2021-01-12 10:31:36', '2021-01-12 10:31:36'),
(72, '690685084', '77782785M', 'Biel', 'Tijerina', 'Terrazas', '990-87-0880', 'hombre', 3, 83836, '2021-01-12 10:31:36', '2021-01-12 10:31:36'),
(73, '109761391', '17762490G', 'Ángela', 'Llorente', 'Serra', '910-57-0147', 'mujer', 1, 80719, '2021-01-12 10:31:36', '2021-01-12 10:31:36'),
(74, '698822534', '80735552D', 'Marina', 'Camarillo', 'Villalobos', '991-150276', 'mujer', 2, 41303, '2021-01-12 10:31:36', '2021-01-12 10:31:36'),
(75, '41252901', '93227031G', 'Pablo', 'Casas', 'Martí', '939-702728', 'hombre', 3, 89043, '2021-01-12 10:31:36', '2021-01-12 10:31:36'),
(76, '5350961', '56698927V', 'Guillermo', 'Manzanares', 'Domínguez', '+34 930 394978', 'mujer', 1, 37246, '2021-01-12 10:33:09', '2021-01-12 10:33:09');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidades`
--

CREATE TABLE `especialidades` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `especialidades`
--

INSERT INTO `especialidades` (`id`, `nombre`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'Traumatología', 'Medicina que se ocupa de las lesiones traumáticas de columna y extremidades que afectan a: Huesos: fracturas (fractura de fémur, fractura de húmero, fractura de Colles), epifisiólisis, etc.', '2021-01-11 15:03:47', '2021-01-11 15:03:47'),
(2, 'Neurología', 'todas aquellas enfermedades que afectan al sistema nervioso central (el cerebro y la médula espinal) y el sistema nervioso periférico (músculos y nervios).', '2021-01-11 15:03:47', '2021-01-11 15:03:47'),
(3, 'Oftalmología', 'es la especialidad médica que estudia las enfermedades de ojo y su tratamiento, incluyendo el globo ocular, su musculatura, el sistema lagrimal y los párpados.', '2021-01-11 15:03:47', '2021-01-11 15:03:47'),
(4, 'Pediatría', 'especialidad médica que estudia al niño y sus enfermedades.', '2021-01-11 15:03:47', '2021-01-11 15:03:47'),
(5, 'Cardiología', 'es la rama de la medicina que se encarga del estudio, diagnóstico y tratamiento de las enfermedades del corazón y del aparato circulatorio.', '2021-01-11 15:03:47', '2021-01-11 15:03:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `horarios`
--

CREATE TABLE `horarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `intervalo` smallint(6) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `horarios`
--

INSERT INTO `horarios` (`id`, `hora_inicio`, `hora_fin`, `intervalo`, `created_at`, `updated_at`) VALUES
(1, '08:00:00', '15:00:00', 15, '2021-01-11 15:03:47', '2021-01-11 15:03:47'),
(2, '15:00:00', '21:00:00', 15, '2021-01-11 15:03:47', '2021-01-11 15:03:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medicos`
--

CREATE TABLE `medicos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `numero_colegiado` char(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dni` char(9) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombre` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apellido1` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apellido2` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` char(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `especialidad_id` bigint(20) DEFAULT NULL,
  `horario_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `medicos`
--

INSERT INTO `medicos` (`id`, `numero_colegiado`, `dni`, `nombre`, `apellido1`, `apellido2`, `telefono`, `especialidad_id`, `horario_id`, `user_id`) VALUES
(29, '101', '273714', 'Andre', 'Romero', 'Monterrey', '04126153080', 2, 2, 7),
(41, '1010', '27371915', 'Andres', 'Velazques', 'Martinez', '64565854', 5, 1, 15),
(42, '10102', '27371918', 'Juan', 'Velazques', 'Martinez', '64565854', 5, 2, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pacientes`
--

CREATE TABLE `pacientes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sip` char(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dni` char(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido1` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido2` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` char(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_nacimiento` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pacientes`
--

INSERT INTO `pacientes` (`id`, `sip`, `dni`, `nombre`, `apellido1`, `apellido2`, `telefono`, `fecha_nacimiento`) VALUES
(13, '102030', '273719256', 'Gabriel Israel', 'Zambrano', 'Garcia', '04126153090', '2024-06-01 13:15:00'),
(22, '45454656', '596030', 'Josue', 'Gonzalez', 'Luna', '04125732754', '2024-06-01 10:47:00'),
(23, '11030', '273719252', 'Juan', 'Rodrigues', 'Monterrey', '0941261530', '2024-06-01 22:01:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(5, 'Sr. Marco Murillo Segundo', 'alejandro11@yahoo.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(6, 'Saúl Arroyo', 'montoya.lara@yahoo.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(7, 'Ing. Gabriela Muñiz', 'daniela91@madrigal.net', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(8, 'José Antonio Pagan', 'veronica48@godinez.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(9, 'Ing. Guillem Lara', 'olivia21@sanz.org', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(10, 'Lola Mojica Segundo', 'lcastano@hispavista.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(11, 'Leo Lovato', 'lidia.sola@regalado.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(12, 'Ing. Francisca Jáquez Hijo', 'carlota.quezada@laureano.net', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(13, 'D. Ander Jiménez Segundo', 'jesus.rangel@hispavista.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(14, 'Sra. Laura Loya', 'ismael12@cruz.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(15, 'Santiago Valdez', 'jesus91@vergara.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(16, 'Gonzalo Quiñones', 'claudia76@yahoo.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(17, 'José Manuel Ordoñez Hijo', 'juana.ibarra@hispavista.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(18, 'José Escamilla Tercero', 'carolina.almonte@cuesta.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(19, 'Inmaculada Zambrano', 'aleix79@leyva.org', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(20, 'Pol Alfaro', 'almaraz.anamaria@saldana.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(21, 'María Dolores Gastélum Tercero', 'zamora.oliver@marco.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(22, 'Jan Gálvez', 'biel70@yahoo.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(23, 'Roberto Ocasio', 'angel56@yahoo.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(24, 'Ian Sepúlveda', 'cvila@fernandez.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(25, 'Carolina Sevilla', 'guerra.nicolas@garza.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(26, 'Aleix Cadena', 'teresa91@orta.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(27, 'Lidia Bonilla', 'nil04@aguilar.com.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(28, 'Rafael Fierro', 'ana.olivarez@cordero.com.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(29, 'Alicia Zarate', 'nicolas95@ballesteros.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(30, 'Hugo Cabán Tercero', 'olivia31@terra.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(31, 'Alba Rivero Segundo', 'anaisabel.mata@villarreal.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(32, 'Alonso Santillán', 'cocampo@terra.com', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(33, 'Leire Olivera', 'miguel01@robles.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(34, 'Guillem Alanis', 'nvanegas@munoz.net', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47'),
(35, 'Guillem De Jesús', 'leo45@aguayo.es', '2021-01-11 15:00:47', '$2y$10$XvnLOKITXMlJAXkPM9g91.YrVNKuexzcRMQaXlRQGV8iWwUKNf.cK', NULL, '2021-01-11 15:00:47', '2021-01-11 15:00:47');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `citas`
--
ALTER TABLE `citas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `U_fecha_paciente_id` (`fecha`,`paciente_id`),
  ADD KEY `citas_enfermero_id_foreign` (`enfermero_id`),
  ADD KEY `citas_paciente_id_foreign` (`paciente_id`);

--
-- Indices de la tabla `enfermeros`
--
ALTER TABLE `enfermeros`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `U_numero_colegiado` (`numero_colegiado`),
  ADD UNIQUE KEY `U_dni` (`dni`),
  ADD KEY `enfermeros_horario_id_foreign` (`horario_id`),
  ADD KEY `enfermeros_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `especialidades`
--
ALTER TABLE `especialidades`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `U_nombre` (`nombre`);

--
-- Indices de la tabla `horarios`
--
ALTER TABLE `horarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `U_hora_inicio_hora_fin_intervalo` (`hora_inicio`,`hora_fin`,`intervalo`);

--
-- Indices de la tabla `medicos`
--
ALTER TABLE `medicos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `U_numero_colegiado` (`numero_colegiado`),
  ADD UNIQUE KEY `U_dni` (`dni`),
  ADD KEY `medicos_especialidad_id_foreign` (`especialidad_id`),
  ADD KEY `medicos_horario_id_foreign` (`horario_id`),
  ADD KEY `medicos_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `pacientes`
--
ALTER TABLE `pacientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `U_sip` (`sip`),
  ADD UNIQUE KEY `U_dni` (`dni`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `citas`
--
ALTER TABLE `citas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT de la tabla `enfermeros`
--
ALTER TABLE `enfermeros`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2000;

--
-- AUTO_INCREMENT de la tabla `especialidades`
--
ALTER TABLE `especialidades`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `horarios`
--
ALTER TABLE `horarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `medicos`
--
ALTER TABLE `medicos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT de la tabla `pacientes`
--
ALTER TABLE `pacientes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100001;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `citas`
--
ALTER TABLE `citas`
  ADD CONSTRAINT `citas_enfermero_id_foreign` FOREIGN KEY (`enfermero_id`) REFERENCES `enfermeros` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
