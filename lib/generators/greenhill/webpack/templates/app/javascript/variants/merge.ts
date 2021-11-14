import { merge as _merge } from 'lodash'
import { styleFn, variant } from 'styled-system'
import { VariantConfigOpts, Variants } from './types'

export type MergeFn = (opts: VariantConfigOpts, baseVariants?: Variants) => styleFn

export const merge: MergeFn = ({ scale, prop, variants={} }, baseVariants={}) => {
  const mergedVariants: Variants = _merge({}, baseVariants)

  Object.keys(variants).map(variant => {
    if (mergedVariants[variant]) {
      mergedVariants[variant] = _merge({}, mergedVariants[variant], variants[variant])
    } else {
      mergedVariants[variant] = _merge({}, mergedVariants[variant], variants[variant])
    }
  })

  return variant({
    prop    : prop,
    scale   : scale,
    variants: mergedVariants,
  })
}

export default merge
