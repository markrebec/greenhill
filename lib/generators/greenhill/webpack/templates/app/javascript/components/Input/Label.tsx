import styled from 'styled-components'
import { Common, Typography, Border, Layout, Flex, CommonProps, TypographyProps, BorderProps, LayoutProps, FlexProps } from 'theme/constants'

export type LabelProps = CommonProps & TypographyProps & BorderProps & LayoutProps & FlexProps

export const Label = styled.label<LabelProps>`
  box-sizing: border-box;
  outline: none;
  ${Typography};
  ${Common};
  ${Border};
  ${Layout};
  ${Flex};
`
Label.defaultProps = {
  fontFamily: 'body',
}

export default Label
