import React, { useContext } from 'react'
import { slice } from 'lodash'
import styled, { StyledComponent, ThemeContext } from 'styled-components'
import { Story } from '@storybook/react/types-6-0'


import { Common, Flex, Layout, Position, CommonProps, LayoutProps, FlexProps } from 'theme/constants'

const Box = styled.div<CommonProps & LayoutProps & FlexProps>`
  ${Common};
  ${Flex};
  ${Layout};
  ${Position};
`


export default {
  title: 'Palette',
}

const swatchBoxAttrs: (props: { bg: string, color: string }) => { style: { background: string, color: string } } = (props) => ({ style: { background: props.bg, color: props.color } })
const SwatchBox: StyledComponent<"div", Record<string, unknown>, { bg: string, style: { background: string, color: string } }, "style"> = styled.div.attrs(swatchBoxAttrs)`
  text-align: center;
  width: 200px;
  padding: 40px 5px;
`
const Swatch: React.FC<{ name: string, bg: string, color: string }> = ({ name, bg, color }) => <SwatchBox bg={bg} color={color}>{name}</SwatchBox>
const Pairs: React.FC<React.PropsWithChildren<Record<string, unknown>>> = props => <Box marginRight={[0, 2, 4]} display="flex" flexDirection="column" {...props} />
const Swatches: React.FC<React.PropsWithChildren<Record<string, unknown>>> = props => <Box display="flex" flexDirection="row" flexWrap="nowrap" {...props} />

const ColorSwatch: React.FC<{ pair: string[], alphas?: boolean}> = ({ pair, alphas=false }) => {
  const theme = useContext(ThemeContext)
  const color = theme.colors[pair[0]]
  const hues = theme.colors[pair[1]]

  const half = Math.floor(hues.length / 2)

  return <Pairs>
    { slice<string>(hues, 0, half).map((hue, h) => {
      return <Swatches key={`${pair[1]}.light.${h}`}>
        <Swatch key={`${pair[1]}.${h}`} name={`${pair[1]}.${h}`} bg={hue} color="black" />
        { alphas && hues.alpha[h].map((_alp: string, a: number) => {
          return <Swatch key={`${pair[1]}.alpha.${h}.${a}`} name={`${pair[1]}.alpha.${h}.${a}`} bg={hues.alpha[h][a]} color="black" />
        }) }
      </Swatches>
    }) }

    <Swatches key={`${pair[0]}.default`}>
      <Swatch key={pair[0]} name={pair[0]} bg={color} color="white" />
      { alphas && hues.alpha[half].map((alp: string, a: number) => {
        return <Swatch key={`${pair[1]}.alpha.${half}.${a}`} name={`${pair[1]}.alpha.${half}.${a}`} bg={alp} color="white" />
      }) }
    </Swatches>

    { slice<string>(hues, half + 1).map((hue, h) => {
      return <Swatches key={`${pair[1]}.dark.${h+6}`}>
        <Swatch key={`${pair[1]}.${h + half + 1}`} name={`${pair[1]}.${h + half + 1}`} bg={hue} color="gray" />
        { alphas && hues.alpha[h + half + 1].map((_alp: string, a: number) => {
          return <Swatch key={`${pair[1]}.alpha.${h + half + 1}.${a}`} name={`${pair[1]}.alpha.${h + half + 1}.${a}`} bg={hues.alpha[h + half + 1][a]} color="gray" />
        }) }
      </Swatches>
    }) }
  </Pairs>
}

const pairs = [
  ['brand', 'branding'],
  ['primary', 'primaries'],
  ['secondary', 'secondaries'],
  ['tertiary', 'tertiaries'],
  ['accent', 'accents'],
  ['info', 'infos'],
  ['warning', 'warnings'],
  ['negative', 'negatives'],
  ['positive', 'positives'],
  ['dark', 'darks'],
  ['light', 'lights'],
  ['black', 'blacks'],
  ['white', 'whites'],
]

export const Colors: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    { pairs.map(pair => <ColorSwatch key={pair[0]} pair={pair} />) }
  </Box>
}

export const Brand: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[0]} alphas />
  </Box>
}

export const Primary: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[1]} alphas />
  </Box>
}

export const Secondary: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[2]} alphas />
  </Box>
}

export const Tertiary: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[3]} alphas />
  </Box>
}

export const Accent: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[4]} alphas />
  </Box>
}

export const Info: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[5]} alphas />
  </Box>
}

export const Warning: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[6]} alphas />
  </Box>
}

export const Negative: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[7]} alphas />
  </Box>
}

export const Positive: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[8]} alphas />
  </Box>
}

export const Dark: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[9]} alphas />
  </Box>
}

export const Light: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[10]} alphas />
  </Box>
}

export const Black: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[11]} alphas />
  </Box>
}

export const White: Story = () => {
  return <Box display="flex" flexWrap="nowrap">
    <ColorSwatch pair={pairs[12]} alphas />
  </Box>
}
