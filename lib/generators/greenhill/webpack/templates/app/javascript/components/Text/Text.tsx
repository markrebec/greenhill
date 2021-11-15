import styled from 'styled-components'
import { textStyle } from 'styled-system'
import { Typography, Common, CommonProps, TypographyProps } from 'theme/constants'

export type TextProps = CommonProps & TypographyProps

export const Text = styled.span<TextProps>`
${Typography};
${Common};
${textStyle};
`
Text.defaultProps = {
  fontFamily: 'body'
}

export default Text
