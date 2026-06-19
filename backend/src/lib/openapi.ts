// OpenAPI 3.0 spec — mirrors the Zod schemas in schema.ts exactly so they never drift.

/* eslint-disable @typescript-eslint/no-explicit-any */
export const spec: Record<string, any> = {
  openapi: '3.0.3',
  info: {
    title: 'Snap & Shop API',
    version: '1.0.0',
    description:
      'Product identification (Claude Vision + Gemini Vision) and real-time price comparison (Google Shopping via SerpAPI).\n\n' +
      'All protected endpoints require `Authorization: Bearer <apple-identity-token>`.',
    contact: { name: 'Snap & Shop', email: 'melakuetf@gmail.com' },
  },
  servers: [
    { url: 'http://localhost:8787', description: 'Local dev (wrangler dev)' },
    { url: 'https://snap-shop-api.workers.dev', description: 'Production (Cloudflare Workers)' },
  ],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        description: 'Sign in with Apple `identity_token` from `ASAuthorizationAppleIDCredential`.',
      },
    },
    schemas: {
      // Mirrors ErrorCode in lib/errors.ts
      ErrorBody: {
        type: 'object',
        required: ['error'],
        properties: {
          error: {
            type: 'object',
            required: ['code', 'message'],
            properties: {
              code: {
                type: 'string',
                enum: ['unauthorized', 'rate_limited', 'invalid_input', 'upstream_error', 'internal'],
              },
              message: { type: 'string', example: 'Human-readable error description.' },
            },
          },
        },
        example: { error: { code: 'unauthorized', message: 'Invalid or expired token' } },
      },
      // Mirrors IdentifyResult Zod schema in lib/schema.ts
      IdentifyResult: {
        type: 'object',
        required: ['brand', 'model', 'category', 'distinguishing_features', 'confidence', 'search_query'],
        properties: {
          brand: { type: 'string', example: 'Sony' },
          model: { type: 'string', example: 'WH-1000XM5' },
          category: { type: 'string', example: 'Over-ear headphones' },
          distinguishing_features: {
            type: 'array',
            items: { type: 'string' },
            example: ['Active noise cancelling', 'Foldable headband', 'USB-C charging'],
          },
          confidence: { type: 'number', minimum: 0, maximum: 1, example: 0.92 },
          search_query: { type: 'string', example: 'Sony WH-1000XM5 headphones' },
        },
      },
      // Mirrors DeepIdentifyItem Zod schema (extends IdentifyResult)
      DeepIdentifyItem: {
        allOf: [
          { $ref: '#/components/schemas/IdentifyResult' },
          {
            type: 'object',
            required: ['frame_index'],
            properties: {
              frame_index: { type: 'integer', minimum: 0, example: 0 },
            },
          },
        ],
      },
      // Mirrors ShopItem Zod schema in lib/schema.ts
      ShopItem: {
        type: 'object',
        required: ['price', 'extracted_price', 'delivery', 'source', 'link', 'thumbnail'],
        properties: {
          price: { type: 'string', example: '$279.99' },
          extracted_price: { type: 'number', example: 279.99 },
          delivery: { type: 'string', example: 'Free delivery' },
          source: { type: 'string', example: 'Amazon.com' },
          link: { type: 'string', format: 'uri', example: 'https://amazon.com/s?k=Sony+WH-1000XM5+headphones' },
          thumbnail: { type: 'string', format: 'uri', example: 'https://encrypted-tbn3.gstatic.com/shopping?q=...' },
        },
      },
    },
    // Reusable error responses — referenced by all three endpoints
    responses: {
      BadRequest: {
        description: 'Missing or invalid field in request body.',
        content: {
          'application/json': {
            schema: { $ref: '#/components/schemas/ErrorBody' },
            example: { error: { code: 'invalid_input', message: 'query must not be empty' } },
          },
        },
      },
      Unauthorized: {
        description: 'Missing or invalid `Authorization: Bearer <jwt>`.',
        content: {
          'application/json': {
            schema: { $ref: '#/components/schemas/ErrorBody' },
            example: { error: { code: 'unauthorized', message: 'Invalid or expired token' } },
          },
        },
      },
      RateLimited: {
        description: 'Daily scan quota exceeded. `Retry-After` gives seconds until midnight UTC reset.',
        headers: {
          'Retry-After': {
            schema: { type: 'integer' },
            description: 'Seconds until the daily quota window resets.',
          },
        },
        content: {
          'application/json': {
            schema: { $ref: '#/components/schemas/ErrorBody' },
            example: { error: { code: 'rate_limited', message: 'Daily precision quota of 10 reached' } },
          },
        },
      },
      UpstreamError: {
        description: 'The upstream AI or price-lookup service returned an error or timed out.',
        content: {
          'application/json': {
            schema: { $ref: '#/components/schemas/ErrorBody' },
            example: { error: { code: 'upstream_error', message: 'Product identification failed' } },
          },
        },
      },
    },
  },
  // Default security applies to all paths; individual operations repeat it for Swagger UI display
  security: [{ bearerAuth: [] }],
  paths: {
    '/identify/precision': {
      post: {
        tags: ['Identify'],
        summary: 'Single-image product identification',
        description:
          'Accepts one product image and returns a structured identification result.\n\n' +
          '**Model**: Claude Sonnet 4.6 → escalates to Opus 4.7 for `X-Tier: pro` requests when `confidence < 0.6`.\n\n' +
          '**Rate limit**: 10 req/day (free) · unlimited (pro).',
        operationId: 'identifyPrecision',
        security: [{ bearerAuth: [] }],
        parameters: [
          {
            in: 'header',
            name: 'X-Tier',
            schema: { type: 'string', enum: ['free', 'pro'] },
            description: 'User subscription tier. Defaults to `free`.',
          },
        ],
        requestBody: {
          required: true,
          content: {
            'multipart/form-data': {
              schema: {
                type: 'object',
                required: ['image'],
                properties: {
                  image: {
                    type: 'string',
                    format: 'binary',
                    description: 'Product image file. Allowed types: `image/jpeg` `image/png` `image/gif` `image/webp`. Max 10 MB.',
                  },
                },
              },
            },
          },
        },
        responses: {
          '200': {
            description: 'Product identified successfully.',
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/IdentifyResult' },
                example: {
                  brand: 'Sony',
                  model: 'WH-1000XM5',
                  category: 'Over-ear headphones',
                  distinguishing_features: ['Active noise cancelling', 'Foldable headband', 'USB-C charging'],
                  confidence: 0.92,
                  search_query: 'Sony WH-1000XM5 headphones',
                },
              },
            },
          },
          '400': { $ref: '#/components/responses/BadRequest' },
          '401': { $ref: '#/components/responses/Unauthorized' },
          '429': { $ref: '#/components/responses/RateLimited' },
          '502': { $ref: '#/components/responses/UpstreamError' },
        },
      },
    },
    '/identify/deep': {
      post: {
        tags: ['Identify'],
        summary: 'Multi-frame video / burst product identification',
        description:
          'Accepts 1–8 image frames (video pan or burst) and returns per-frame identification results.\n\n' +
          '**Model**: Gemini 2.5 Flash → escalates to Gemini 2.5 Pro when `max(confidence) < 0.6`.\n\n' +
          '**Rate limit**: 30 req/day (free) · 200 req/day (pro).',
        operationId: 'identifyDeep',
        security: [{ bearerAuth: [] }],
        parameters: [
          {
            in: 'header',
            name: 'X-Tier',
            schema: { type: 'string', enum: ['free', 'pro'] },
            description: 'User subscription tier. Defaults to `free`.',
          },
        ],
        requestBody: {
          required: true,
          content: {
            'multipart/form-data': {
              schema: {
                type: 'object',
                required: ['frames[]'],
                properties: {
                  'frames[]': {
                    type: 'array',
                    items: { type: 'string', format: 'binary' },
                    minItems: 1,
                    maxItems: 8,
                    description: 'Image frames (JPEG/PNG/GIF/WebP, max 10 MB each). Use field name `frames[]` for every frame.',
                  },
                  hint: {
                    type: 'string',
                    description: 'Optional free-text hint to guide identification.',
                    example: 'noise cancelling headphones',
                  },
                },
              },
            },
          },
        },
        responses: {
          '200': {
            description: 'Array of per-frame identification results.',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/DeepIdentifyItem' } },
                example: [
                  {
                    brand: 'Sony',
                    model: 'WH-1000XM5',
                    category: 'Over-ear headphones',
                    distinguishing_features: ['Active noise cancelling'],
                    confidence: 0.88,
                    search_query: 'Sony WH-1000XM5 headphones',
                    frame_index: 0,
                  },
                ],
              },
            },
          },
          '400': { $ref: '#/components/responses/BadRequest' },
          '401': { $ref: '#/components/responses/Unauthorized' },
          '429': { $ref: '#/components/responses/RateLimited' },
          '502': { $ref: '#/components/responses/UpstreamError' },
        },
      },
    },
    '/shop': {
      post: {
        tags: ['Shop'],
        summary: 'Price lookup across retailers',
        description:
          'Queries Google Shopping via SerpAPI for the given search query with optional retailer whitelist filtering. Results are **cached for 1 hour** in Upstash Redis.\n\n' +
          'Tip: pass `search_query` from `/identify/precision` or `/identify/deep` directly as `query`.',
        operationId: 'shop',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['query', 'retailer_whitelist'],
                properties: {
                  query: {
                    type: 'string',
                    minLength: 1,
                    description: 'Product search query. Use `search_query` from the identify endpoints for best results.',
                    example: 'Sony WH-1000XM5 headphones',
                  },
                  retailer_whitelist: {
                    type: 'array',
                    items: { type: 'string' },
                    description: 'Case-insensitive retailer name substrings. Empty array returns all retailers (up to 10 results).',
                    example: ['Amazon', 'Walmart', 'Best Buy', 'Target'],
                  },
                },
              },
              example: {
                query: 'Sony WH-1000XM5 headphones',
                retailer_whitelist: ['Amazon', 'Walmart', 'Best Buy'],
              },
            },
          },
        },
        responses: {
          '200': {
            description: 'Up to 10 price results sorted by relevance.',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/ShopItem' } },
                example: [
                  {
                    price: '$279.99',
                    extracted_price: 279.99,
                    delivery: 'Free delivery',
                    source: 'Amazon.com',
                    link: 'https://amazon.com/s?k=Sony+WH-1000XM5+headphones',
                    thumbnail: '',
                  },
                  {
                    price: '$289.95',
                    extracted_price: 289.95,
                    delivery: '2-day shipping',
                    source: 'Walmart',
                    link: 'https://walmart.com/search?q=Sony+WH-1000XM5+headphones',
                    thumbnail: '',
                  },
                ],
              },
            },
          },
          '400': { $ref: '#/components/responses/BadRequest' },
          '401': { $ref: '#/components/responses/Unauthorized' },
          '502': { $ref: '#/components/responses/UpstreamError' },
        },
      },
    },
  },
}

// Swagger UI HTML — loads the CDN bundle and points it at /swagger.json
export const swaggerUiHtml = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Snap &amp; Shop API Docs</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5.18.2/swagger-ui.css" />
  <style>
    body { margin: 0; }
    .swagger-ui .topbar { background: #1a1a2e; }
    .swagger-ui .topbar .download-url-wrapper { display: none; }
  </style>
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist@5.18.2/swagger-ui-bundle.js"></script>
  <script>
    window.onload = () => {
      SwaggerUIBundle({
        url: '/swagger.json',
        dom_id: '#swagger-ui',
        presets: [SwaggerUIBundle.presets.apis, SwaggerUIBundle.SwaggerUIStandalonePreset],
        layout: 'BaseLayout',
        deepLinking: true,
        defaultModelsExpandDepth: 1,
        defaultModelExpandDepth: 2,
        displayRequestDuration: true,
        tryItOutEnabled: true,
      })
    }
  </script>
</body>
</html>`
