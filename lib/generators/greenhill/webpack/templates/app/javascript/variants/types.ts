import * as CSS from 'csstype'
import { CustomTheme } from '../components/Application/theme'
import { PaletteColor } from '../primitives/colors/palette'
import { CommonProps, TypographyProps, BorderProps, LayoutProps, PositionProps, GridProps, FlexProps } from '../constants'

export type Color = PaletteColor | CSS.Property.Color

/** Theme props used to apply theming to variant styles */
export interface VariantThemeProps {
  /** The theme provided via context */
  theme: CustomTheme
}

/** Component props used to select the best available color for color-based variants (i.e. backgroundColor, color) */
export interface VariantColorProps extends VariantThemeProps {
  /** Override the theme color to use in this variant */
  color?: Color
}

/** Attempts to use the best available color based on component props with fallback */
export type ColorFallbackFn<P=VariantThemeProps> = (props: P, fallback: string) => string

export type Variant = CommonProps & TypographyProps & BorderProps & LayoutProps & PositionProps & GridProps & FlexProps

export type Variants = Record<string, Variant>

/** Returns an object defining base variant styles */
export type VariantDefaultsFn<T=Variants, P=VariantThemeProps> = (props: P & { [index: string]: unknown }) => T

/** Variant config options */
export type VariantConfigOpts = {
  /** The name of the theme scale to use for this variant */
  scale: string;
  /** The name of the component prop to use for this variant */
  prop?: string;
  /** Object providing base variant styles */
  variants?: Variants;
}

/** Creates a style function that can be used as a variant in a styled component */
export type VariantStyleFn<T=Variants, P=VariantThemeProps> = (props: P & { [index: string]: unknown }) => T

export type VariantFn<T=Variants, P=VariantThemeProps, A=VariantConfigOpts> = (args: A) => VariantStyleFn<T, P>


/** The default, optional component prop used for variants */
export type VariantComponentProps<T=string> = {
  /** The name of the component themed variant to render */
  variant?: T
}

/** Generic type used to override the default component prop used for a custom variant `ComponentVariantProps<'customVariant', 'foo' | 'bar'>` */
export type ComponentVariantProps<T extends string=keyof VariantComponentProps, V=VariantComponentProps['variant']> = {
  [K in T]?: V
}

/** Generic type used to augment or override the default component prop used for a custom variant `CombinedVariantProps<{ variant: string, foo?: 'bar' | 'baz' }>` */
export type CombinedVariantProps<P, V=string, T=VariantComponentProps<V>> = {
  [K in keyof (P & T)]: (P & T)[K]
}