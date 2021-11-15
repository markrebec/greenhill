import * as CSS from 'csstype'
import * as SS from 'styled-system'

export type WhiteSpaceProps<ThemeType extends SS.Theme = SS.RequiredTheme> = {
    /**
     * The white-space CSS property specifies the wrapping behavior of an inline or table-cell box.
     *
     * [MDN reference](https://developer.mozilla.org/en-US/docs/Web/CSS/white-space)
     */
    whiteSpace?: SS.ResponsiveValue<CSS.Property.WhiteSpace, ThemeType>;
}

export type TextTransformProps<ThemeType extends SS.Theme = SS.RequiredTheme> = {
    /**
     * The text-transform CSS property specifies the capitalization of an inline or table-cell box.
     *
     * [MDN reference](https://developer.mozilla.org/en-US/docs/Web/CSS/text-transform)
     */
    textTransform?: SS.ResponsiveValue<CSS.Property.TextTransform, ThemeType>;
}

// NOTE there is a conflict between the `color` props for styled-components and styled-system
//      this is a bit of a hack to allow them to play nicely together
export type TextColorProps = {
  /**
   * The color utility parses a component's `color` and `bg` props and converts them into CSS declarations.
   * By default the raw value of the prop is returned.
   *
   * Color palettes can be configured with the ThemeProvider to use keys as prop values, with support for dot notation.
   * Array values are converted into responsive values.
   *
   * [MDN reference](https://developer.mozilla.org/en-US/docs/Web/CSS/color)
   */
  color?: string | (string & string[]) | undefined;
}

const { system, compose, border, color, display, flexbox, grid, layout, position, shadow, space, typography } = SS

export const whiteSpace: SS.styleFn = system({
  whiteSpace: {
    property   : 'whiteSpace',
  }
})

export const textTransform: SS.styleFn = system({
  textTransform: {
    property   : 'textTransform',
  }
})

export const Typography: SS.styleFn = compose(typography, whiteSpace, textTransform)
export type TypographyProps = SS.TypographyProps & TextTransformProps & WhiteSpaceProps

export const Common: SS.styleFn = compose(space, color, display)
export type CommonProps = SS.SpaceProps & SS.DisplayProps & SS.BackgroundColorProps & TextColorProps & SS.OpacityProps

export const Border: SS.styleFn = compose(border, shadow)
export type BorderProps = SS.BorderProps & SS.ShadowProps

export const Layout: SS.styleFn = layout
export type LayoutProps = SS.LayoutProps

export const Position: SS.styleFn = position
export type PositionProps = SS.PositionProps

export const Flex: SS.styleFn = flexbox
export type FlexProps = SS.FlexboxProps

export const Grid: SS.styleFn = grid
export type GridProps = SS.GridProps

                                            // TODO can we just re-compose the constants?
export const Combined: SS.styleFn = compose(layout, position, flexbox, grid, space, color, display, typography, whiteSpace, textTransform, border, shadow)
export type CombinedProps = LayoutProps & PositionProps & FlexProps & GridProps & CommonProps & TypographyProps & BorderProps