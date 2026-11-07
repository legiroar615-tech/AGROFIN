-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema agrofin
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema agrofin
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `agrofin` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `agrofin` ;

-- -----------------------------------------------------
-- Table `agrofin`.`categoria_movimiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`categoria_movimiento` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `tipo` VARCHAR(20) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`id_categoria`),
  UNIQUE INDEX `uq_categoria_movimiento_nombre` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`tipo_cultivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`tipo_cultivo` (
  `id_tipo_cultivo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`id_tipo_cultivo`),
  UNIQUE INDEX `uq_tipo_cultivo_nombre` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`cultivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`cultivo` (
  `id_cultivo` INT NOT NULL AUTO_INCREMENT,
  `id_tipo_cultivo` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `fecha_siembra` DATE NOT NULL,
  `fecha_estimada_cosecha` DATE NULL DEFAULT NULL,
  `extension_terreno` DECIMAL(10,2) NOT NULL,
  `descripcion` VARCHAR(500) NULL DEFAULT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`id_cultivo`),
  INDEX `fk_cultivo_tipo` (`id_tipo_cultivo` ASC) VISIBLE,
  CONSTRAINT `fk_cultivo_tipo`
    FOREIGN KEY (`id_tipo_cultivo`)
    REFERENCES `agrofin`.`tipo_cultivo` (`id_tipo_cultivo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `correo` VARCHAR(150) NOT NULL,
  `contrasena` VARCHAR(255) NOT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `uq_usuario_correo` (`correo` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`egreso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`egreso` (
  `id_egreso` INT NOT NULL AUTO_INCREMENT,
  `id_cultivo` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_categoria` INT NOT NULL,
  `fecha` DATE NOT NULL,
  `monto` DECIMAL(12,2) NOT NULL,
  `descripcion` VARCHAR(255) NOT NULL,
  `observaciones` VARCHAR(500) NULL DEFAULT NULL,
  PRIMARY KEY (`id_egreso`),
  INDEX `fk_egreso_cultivo` (`id_cultivo` ASC) VISIBLE,
  INDEX `fk_egreso_usuario` (`id_usuario` ASC) VISIBLE,
  INDEX `fk_egreso_categoria` (`id_categoria` ASC) VISIBLE,
  CONSTRAINT `fk_egreso_categoria`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `agrofin`.`categoria_movimiento` (`id_categoria`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_egreso_cultivo`
    FOREIGN KEY (`id_cultivo`)
    REFERENCES `agrofin`.`cultivo` (`id_cultivo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_egreso_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `agrofin`.`usuario` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`comprobante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`comprobante` (
  `id_comprobante` INT NOT NULL AUTO_INCREMENT,
  `id_egreso` INT NOT NULL,
  `numero_comprobante` VARCHAR(50) NOT NULL,
  `fecha_generacion` DATE NOT NULL,
  `archivo_pdf` VARCHAR(255) NULL DEFAULT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`id_comprobante`),
  UNIQUE INDEX `uq_comprobante_numero` (`numero_comprobante` ASC) VISIBLE,
  INDEX `fk_comprobante_egreso` (`id_egreso` ASC) VISIBLE,
  CONSTRAINT `fk_comprobante_egreso`
    FOREIGN KEY (`id_egreso`)
    REFERENCES `agrofin`.`egreso` (`id_egreso`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`etapa_cultivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`etapa_cultivo` (
  `id_etapa` INT NOT NULL AUTO_INCREMENT,
  `id_cultivo` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(500) NULL DEFAULT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NULL DEFAULT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
  PRIMARY KEY (`id_etapa`),
  INDEX `fk_etapa_cultivo_cultivo` (`id_cultivo` ASC) VISIBLE,
  CONSTRAINT `fk_etapa_cultivo_cultivo`
    FOREIGN KEY (`id_cultivo`)
    REFERENCES `agrofin`.`cultivo` (`id_cultivo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`ingreso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`ingreso` (
  `id_ingreso` INT NOT NULL AUTO_INCREMENT,
  `id_cultivo` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_categoria` INT NOT NULL,
  `fecha` DATE NOT NULL,
  `descripcion` VARCHAR(255) NOT NULL,
  `monto` DECIMAL(12,2) NOT NULL,
  `observaciones` VARCHAR(500) NULL DEFAULT NULL,
  PRIMARY KEY (`id_ingreso`),
  INDEX `fk_ingreso_cultivo` (`id_cultivo` ASC) VISIBLE,
  INDEX `fk_ingreso_usuario` (`id_usuario` ASC) VISIBLE,
  INDEX `fk_ingreso_categoria` (`id_categoria` ASC) VISIBLE,
  CONSTRAINT `fk_ingreso_categoria`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `agrofin`.`categoria_movimiento` (`id_categoria`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ingreso_cultivo`
    FOREIGN KEY (`id_cultivo`)
    REFERENCES `agrofin`.`cultivo` (`id_cultivo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ingreso_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `agrofin`.`usuario` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`notificacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`notificacion` (
  `id_notificacion` INT NOT NULL AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `tipo` VARCHAR(50) NOT NULL,
  `mensaje` VARCHAR(500) NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `leida` TINYINT(1) NOT NULL DEFAULT '0',
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`id_notificacion`),
  INDEX `fk_notificacion_usuario` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_notificacion_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `agrofin`.`usuario` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`rol` (
  `id_rol` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`id_rol`),
  UNIQUE INDEX `uq_rol_nombre` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`socio_cultivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`socio_cultivo` (
  `id_usuario` INT NOT NULL,
  `id_cultivo` INT NOT NULL,
  `funcion` VARCHAR(100) NOT NULL,
  `porcentaje_participacion` DECIMAL(5,2) NOT NULL,
  `fecha_asociacion` DATE NOT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`id_usuario`, `id_cultivo`),
  INDEX `fk_socio_cultivo_cultivo` (`id_cultivo` ASC) VISIBLE,
  CONSTRAINT `fk_socio_cultivo_cultivo`
    FOREIGN KEY (`id_cultivo`)
    REFERENCES `agrofin`.`cultivo` (`id_cultivo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_socio_cultivo_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `agrofin`.`usuario` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `agrofin`.`usuario_rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `agrofin`.`usuario_rol` (
  `id_usuario` INT NOT NULL,
  `id_rol` INT NOT NULL,
  `fecha_asignacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`id_usuario`, `id_rol`),
  INDEX `fk_usuario_rol_rol` (`id_rol` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_rol_rol`
    FOREIGN KEY (`id_rol`)
    REFERENCES `agrofin`.`rol` (`id_rol`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_usuario_rol_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `agrofin`.`usuario` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
