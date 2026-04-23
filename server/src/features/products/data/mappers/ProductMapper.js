import { Product } from '../../domain/entities/Product.js'
import { CreateProductRequestDto, UpdateProductRequestDto } from '../dtos/ProductRequestDtos.js'
import { ProductResponseDto } from '../dtos/ProductResponseDtos.js'

/**
 * Product Mapper - Data Layer
 * Handles transformations between DTOs and Domain Entities
 */
export class ProductMapper {
  /**
   * Convert database row to Product entity
   * @param {Object} dbRow - Database row from Supabase
   * @returns {Product}
   */
  static toEntity(dbRow) {
    if (!dbRow) return null

    return new Product({
      id: dbRow.id,
      dealerId: dbRow.dealer_id,
      categoryId: dbRow.category_id,
      title: dbRow.title,
      description: dbRow.description,
      unitPrice: dbRow.unit_price,
      stock: dbRow.stock,
      isActive: dbRow.is_active,
      createdAt: dbRow.created_at,
      updatedAt: dbRow.updated_at
    })
  }

  /**
   * Convert Product entity to database format
   * @param {Product} product - Product entity
   * @returns {Object}
   */
  static toDatabase(product) {
    return {
      id: product.id,
      dealer_id: product.dealerId,
      category_id: product.categoryId,
      title: product.title,
      description: product.description,
      unit_price: product.unitPrice,
      stock: product.stock,
      is_active: product.isActive,
      created_at: product.createdAt,
      updated_at: product.updatedAt
    }
  }

  /**
   * Convert create request DTO to database insert format
   * @param {CreateProductRequestDto} dto - Create request DTO
   * @param {string} dealerId - Dealer ID
   * @returns {Object}
   */
  static createRequestToDatabase(dto, dealerId) {
    return {
      dealer_id: dealerId,
      category_id: dto.categoryId,
      title: dto.title,
      description: dto.description,
      unit_price: dto.unitPrice,
      stock: dto.stock,
      is_active: true
    }
  }

  /**
   * Convert update request DTO to database update format
   * @param {UpdateProductRequestDto} dto - Update request DTO
   * @returns {Object}
   */
  static updateRequestToDatabase(dto) {
    const dbData = {}

    if (dto.updates.title !== undefined) dbData.title = dto.updates.title
    if (dto.updates.description !== undefined) dbData.description = dto.updates.description
    if (dto.updates.unitPrice !== undefined) dbData.unit_price = dto.updates.unitPrice
    if (dto.updates.stock !== undefined) dbData.stock = dto.updates.stock
    if (dto.updates.categoryId !== undefined) dbData.category_id = dto.updates.categoryId
    if (dto.updates.isActive !== undefined) dbData.is_active = dto.updates.isActive

    return dbData
  }

  /**
   * Convert Product entity to response DTO
   * @param {Product} product - Product entity
   * @returns {Object}
   */
  static toResponseDto(product) {
    if (!product) return null
    return new ProductResponseDto(product).toJSON()
  }

  /**
   * Convert array of Product entities to response DTOs
   * @param {Product[]} products - Array of Product entities
   * @returns {Object[]}
   */
  static toResponseDtoList(products) {
    if (!products) return []
    return products.map(product => this.toResponseDto(product))
  }
}