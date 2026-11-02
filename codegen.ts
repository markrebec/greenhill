import type { CodegenConfig } from '@graphql-codegen/cli'

const config: CodegenConfig = {
  schema: 'schema.graphql',
  documents: ['src/**/*.{ts,tsx}'],
  generates: {
    './src/graphql/generated/': {
      preset: 'client',
      presetConfig: {
        gqlTagName: 'gql',
      },
      config: {
        useTypeImports: true,
        // Custom scalars arrive as JSON strings (ISO 8601 timestamps; BigInt
        // as a decimal string so it can't lose precision).
        scalars: {
          ISO8601DateTime: 'string',
          BigInt: 'string',
        },
      },
    },
  },
}

export default config
